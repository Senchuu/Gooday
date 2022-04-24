# frozen_string_literal: true

require "gooday/version"
require "gooday/index"

module Gooday
  def self.new(context)
    Gooday::Date.new(context)
  end

  def self.module(module_name)
    if module_name.is_a?(String)
      Gooday::Date.include(Gooday::Modules.const_get(module_name))
    else
      Gooday::Date.include(module_name)
    end
  end
end
