# frozen_string_literal: true

require "yaml"

module Gooday
  # Use YAML instead of Ruby to set a translation
  class YAMLParser
    AUTHORIZED_KEYS = %w[short long months days short_months short_days formats].freeze

    def initialize(file)
      @file = YAML.load_file(file)
    end

    def translations
      @file.each_with_object({}) do |(key, value), hash|
        hash[key] = value if AUTHORIZED_KEYS.include?(key)
      end
    end
  end
end
