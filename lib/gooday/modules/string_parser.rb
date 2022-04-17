# frozen_string_literal: true

module Gooday
  module Modules
    module StringParser
      def parse_string(string)
        parsed = translations[:regexes].each_with_object([]) do |regex, arr|
          arr << string.match(regex) if string.match?(regex)
        end
        return nil if parsed.empty?

        parsed.map { |p| Gooday.new(DateTime.new(p["year"].to_i || Time.now.year, translations[:months].index(p["month"]) & +1 || p["month"].to_i, p["day"].to_i)) }
      end
    end
  end
end

class String
  def parse; end
end
