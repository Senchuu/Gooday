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
      Date.attr_accessor :year, :month, :day, :hour, :min, :sec, :zone
      @year = context.year
      @month = context.month
      @day = context.day
      @wday = context.wday
      @hour = context.hour
      @min = context.min
      @sec = context.sec
      @zone = context.zone
    end

    def locale(locale, target: "ruby", path: nil)
      if target.downcase.match?(/yml/)
        raise Gooday::Error, "#{locale.inspect} doesn't exist as a locale format" unless File.exist?(path.nil? ? "./lib/gooday/locales/#{locale}.yml" : "#{path}/#{locale}.yml")

        require "gooday/yaml_parser"
        @translations = YAMLParser.new(path.nil? ? "./lib/gooday/locales/#{locale}.yml" : "#{path}/#{locale}.yml").translations.transform_keys(&:to_sym)
      else
        raise Gooday::Error, "#{locale.inspect} doesn't exist as a locale format" unless File.exist?(path.nil? ? "./lib/gooday/locales/#{locale}.rb" : "#{path}/#{locale}.rb")

        require File.expand_path("./locales/#{locale}", File.dirname(__FILE__))
        missing_keys = %i[short long days months short_days short_months formats regexes].each_with_object([]) do |key, arr|
          arr << key unless Gooday::Locales.method(locale.to_s.downcase).call[key]
        end
        raise Gooday::Error, "#{locale.inspect} is missing the following keys: #{missing_keys.join(", ")}" unless missing_keys.empty?

        @translations = Gooday::Locales.method(locale.to_s.downcase).call
        $LOAD_PATH.unshift(File.expand_path("./locales/#{locale}", File.expand_path(__FILE__)))
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

    def to_s
      @context.to_s
    end
  end
end

def gooday?(object)
  object.is_a?(Gooday::Date)
end
