# frozen_string_literal: true

require "gooday/modules/timestamps"

RSpec.describe Gooday do
  it "has a version number" do
    expect(Gooday::VERSION).not_to be nil
  end

  it "works" do
    gooday = Gooday::Date.new(Time.now)
    p gooday.translations
    expect(gooday.month).to be 4
  end

  it "checks if an object is a gooday" do
    expect(gooday?(Date.new)).to be false
  end

  it "has a valid duration module" do
    Gooday::Date.include(Gooday::Modules::Timestamps)
    expect(Gooday.new(Time.now).to_timestamp.to_gooday).not_to be nil
  end

  it "YAML parser" do
    require "gooday/yaml_parser"

    p Gooday::YAMLParser.new("spec/locales/fr.yml").translations
  end

  it "string_parser" do
    require "gooday/modules/string_parser"
    Gooday::Date.include(Gooday::Modules::StringParser)
    date = Gooday.new(Time.now)
    date.locale("fr")
    parsed = date.parse_string("Nous sommes le 17/02/2021. Demain nous serons le 18 Février 2021")
    p parsed.map { |p| p.format("DD D MM YYYY") }
  end
end
