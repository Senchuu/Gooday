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

    def locale(locale)
      raise Gooday::Error, "#{locale.inspect} doesn't exist as a locale format" unless File.exist?("./lib/gooday/locales/#{locale}.rb")

      require File.expand_path("./locales/#{locale}", File.dirname(__FILE__))
      @translations = Gooday::Locales.method(locale.to_s.downcase).call
      $LOAD_PATH.unshift(File.expand_path("./locales/#{locale}", File.expand_path(__FILE__)))
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

    def to_s
      @context.to_s
    end
  end
end

def gooday?(object)
  object.is_a?(Gooday::Date)
end
