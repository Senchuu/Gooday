# frozen_string_literal: false

module Gooday
  class Error < StandardError
    def initialize(msg = "Gooday Error")
      super(msg.match?("Gooday Error") ? msg : (+"Gooday Error: ").concat(msg))
    end
  end
end
