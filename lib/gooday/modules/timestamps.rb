# frozen_string_literal: true

module Gooday
  module Modules
    module Timestamps
      def to_timestamp
        context.to_time.to_i
      end
    end
  end
end

class Integer
  def to_gooday
    Gooday.new(Time.at(self))
  end
end
