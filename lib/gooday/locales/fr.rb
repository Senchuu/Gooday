# frozen_string_literal: true

module Gooday
  module Locales
    def self.fr
      formats = Hash[
        :short => "fr",
        :long => "Français",
        :months => %w[
          Janvier
          Février
          Mars
          Avril
          Mai
          Juin
          Juillet
          Août
          Septembre
          Octobre
          Novembre
          Décembre
        ],
        :days => %w[
          Dimanche
          Lundi
          Mardi
          Mercredi
          Jeudi
          Vendredi
          Samedi
        ],
        :formats => {
          :default => "%d %B %Y",
          :short => "%d %b",
          :long => "%d %B %Y"
        },
        :regexes => [
          %r{(?<day>\d{1,2})/(?<month>\d{1,2})/(?<year>\d{4}|\d{2})?}
        ]
      ]

      formats.store(:short_days, formats[:days].map { |day| day[0, 3] })
      formats.store(:short_months, formats[:months].map { |month| month.size <= 4 ? month : month[0, 3] })
      formats[:regexes] << /((?<wday>#{formats[:days].join("|")})\s)?(?<day>\d{1,2})\s(?<month>#{formats[:months].join("|")})\s+?(?<year>\d{4}|\d{2})?/
      formats
    end
  end
end
