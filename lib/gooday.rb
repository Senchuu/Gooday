# frozen_string_literal: true

require "gooday/version"
require "gooday/index"

module Gooday
  def self.new(context)
    Gooday::Date.new(context)
  end
end
