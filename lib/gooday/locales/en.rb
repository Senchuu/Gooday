# frozen_string_literal: true

module Gooday
  module Locales
    def self.en
      formats = Hash[
        :short => "en",
        :long => "English",
        :months => %w[
          January
          February
          March
          April
          May
          June
          July
          August
          September
          October
          November
          December
        ],
        :days => %w[
          Sunday
          Monday
          Tuesday
          Wednesday
          Thursday
          Friday
          Saturday
        ],
        :formats => {
          :default => "%a, %d %b %Y %H:%M:%S %z",
          :short => "%d %b %H:%M",
          :long => "%B %d, %Y %H:%M"
        }
      ]
      formats.store(:short_days, formats[:days].map { |day| day[0, 3] })
      formats.store(:short_months, formats[:months].map { |month| month.size <= 4 ? month : month[0, 3] })
      formats
    end
  end
end
