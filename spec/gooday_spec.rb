# frozen_string_literal: true

require "gooday/modules/timestamps"

RSpec.describe Gooday do
  it "has a version number" do
    expect(Gooday::VERSION).not_to be nil
  end

  it "works" do
    gooday = Gooday::Date.new(Time.now)
    p gooday.format("hello English: D MM YYYY hh:mm:ss z")
    gooday.locale("fr")
    p gooday.format("hello French: D MM YYYY hh:mm:ss z")
    expect(gooday.month).to be 4
  end

  it "checks if an object is a gooday" do
    expect(gooday?(Date.new)).to be false
  end

  it "has a valid duration module" do
    Gooday::Date.include(Gooday::Modules::Timestamps)
    expect(Gooday.new(Time.now).to_timestamp.to_gooday).not_to be nil
  end
end
