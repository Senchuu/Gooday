# frozen_string_literal: true

require "gooday/errors"
require "date"
require "time"

module Gooday
  class Date
    attr_accessor :context
    attr_reader :translations

    def initialize(context)
      raise Gooday::Error, "#{context.inspect} is an invalid context" unless context.respond_to?(:to_datetime)

      @context = context.to_datetime
      init
      locale("en")
    end

    def init(context = @context)
      Date.attr_accessor :year, :month, :day, :wday, :hour, :min, :sec, :zone
      @year = context.year
      @month = context.month
      @day = context.day
      @wday = context.wday || @wday
      @hour = context.hour
      @min = context.min
      @sec = context.sec
      @zone = context.zone
    end

    def locale(locale, path: false, target: "ruby")
      if target.downcase.match?(/^(yml|yaml)/)
        raise Gooday::Error, "#{locale.inspect} doesn't exist as a YAML locale format" unless File.exist?(File.expand_path("#{locale}.yml", path))

        require "gooday/yaml_parser"
        @translations = YAMLParser.new(File.expand_path("#{locale}.yml", path))
                                  .translations.transform_keys(&:to_sym)
      else
        raise Gooday::Error, "#{locale.inspect} doesn't exist as a RUBY locale format" unless File.exist?(path ? File.expand_path("#{locale}.rb", path) : "./lib/gooday/locales/#{locale}.rb")

        file = if path
                 File.expand_path("#{locale}.rb", path)
               else
                 File.expand_path("./locales/#{locale}.rb", File.dirname(__FILE__))
               end
        load file

        missing_keys = %i[short long days months short_days short_months formats regexes].each_with_object([]) do |key, arr|
          arr << key unless Gooday::Locales.method(locale.to_s.downcase).call[key]
        end
        raise Gooday::Error, "#{locale.inspect} is missing the following keys: #{missing_keys.join(", ")}" unless missing_keys.empty?

        @translations = Gooday::Locales.method(locale.to_s.downcase).call
        $LOAD_PATH.unshift(file)
      end
    end

    def format(format_string)
      raise Gooday::Error, "#{format_string.inspect} is not a valid format string" unless format_string.is_a?(String)

      matches = Hash[
        :YYYY => @year,
        :YY => @year.to_s[-2..-1],
        :M => @month,
        :MM => @translations[:months][@month - 1],
        :MMM => @translations[:short_months][@month - 1],
        :D => @day,
        :DD => @translations[:days][@wday],
        :DDD => @translations[:short_days][@wday],
        :hh => @hour,
        :mm => @min,
        :ss => @sec,
        :z => @zone
      ]

      format_string.gsub(/\w+/) { |match| matches[match.to_sym] || match }
    end

    def set(year: nil, month: nil, day: nil, hour: nil, min: nil, sec: nil, zone: nil)
      month = @translations[:months].index(month) + 1 || nil if month.is_a?(String)
      init(Class.new(DateTime) do
        def initialize(year, month, day, hour, min, sec, zone)
          @year = year
          @month = month
          @day = day
          @hour = hour
          @min = min
          @sec = sec
          @zone = zone
        end
      end.new(year || @year, month || @month, day || @day, hour || @hour, min || @min, sec || @sec, zone || @zone))
    end

    def add(years: 0, months: 0, days: 0, hours: 0, mins: 0, secs: 0)
      calculated_days = nil
      loop do
        month_days = Time.__send__(:month_days, @year, @month)
        calculated_days ||= @day + days
        break if month_days >= calculated_days

        calculated_days -= month_days
        if @month == 12
          @year += 1
          @month = 1
        else
          @month += 1
        end
      end

      set(
        :year => @year + years,
        :month => @month + months,
        :day => calculated_days || @day + days,
        :hour => @hour + hours,
        :min => @min + mins,
        :sec => @sec + secs
      )
    end

    def to_hash
      Hash[
        :year => @year,
        :month => @month,
        :day => @day,
        :wday => @wday,
        :hour => @hour,
        :min => @min,
        :sec => @sec,
        :zone => @zone
      ]
    end

    def clone
      Date.new(DateTime.new(@year, @month, @day, @hour, @min, @sec))
    end

    def to_s
      @context.to_s
    end
  end
end

def gooday?(object)
  object.is_a?(Gooday::Date)
end

