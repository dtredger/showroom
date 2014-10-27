require 'rspec'
require 'rails_helper'
require 'rake'

Dir[Rails.root.join('lib/tasks/*.rb')].each { |f| require f }

RSpec.describe 'Basic Scraper' do

  VALID_URL = 'https://www.google.ca'

  context "initialize" do
    pending
  end

  context "open_url" do
    it "fetches DOM with nokogiri" do
      basic_scraper = BasicScraper.allocate
      site = basic_scraper.open_url(VALID_URL)

      expect(site.class).to eq(Nokogiri::HTML::Document)
    end

    it "returns msg if DOM unavailable" do
      pending
    end
  end

  context "resize_image" do
    pending
  end

  context "format_item_to_local_url_path" do
    pending
  end




end