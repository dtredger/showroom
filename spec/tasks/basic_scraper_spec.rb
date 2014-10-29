require 'rspec'
require 'rails_helper'
require 'rake'

Dir[Rails.root.join('lib/tasks/*.rb')].each { |f| require f }

RSpec.describe 'Basic Scraper' do

  VALID_URL = 'https://www.google.ca'
  SAMPLE_IMAGE_PATH = "#{Rails.root}/public/images/doge_log.gif"
  basic_scraper = BasicScraper.new

  context "open_url" do
    describe "valid url" do
      it "fetches DOM" do
        site = basic_scraper.open_url(VALID_URL)
        expect(site.class).to eq(Nokogiri::HTML::Document)
      end
    end

    describe "bad url" do
      it "returns error if DOM unavailable" do
        response = basic_scraper.open_url('a bad url!')
        expect(response).to eq('Open_url Error: No such file or directory - a bad url!')
      end
    end
  end


  context "#download_image" do
    describe "invalid url" do
      it "returns general error" do
        file = basic_scraper.download_image "bogus!"
        expect(file).to eq("General Resize error: No such file or directory - bogus!")
      end
    end

    describe "url not image" do
      it "returns ImageMagickError" do
        file = basic_scraper.download_image VALID_URL
        expect(file).to eq("ImageMagickError: bad image format - #{VALID_URL}")
      end
    end

    describe "valid url" do
      it "returns file" do
        file = basic_scraper.download_image "http://placekitten.com/g/200/200"
        expect(file).to be_kind_of(Magick::Image)
      end
    end

  end


  context "#resize_image" do
    describe "failure" do
      it "returns error" do
        pending
      end
    end

    describe "success" do
      it "returns new file" do
        pending
        file = open(SAMPLE_IMAGE_PATH)
        resized_file = resize_image(file)
        expect resized_file.to be_kind_of(File)
      end

    end
  end


  context "#save_item" do
    describe "failure" do
      it "returns error" do
        pending
      end
    end

    describe "success" do
      it "returns saved item" do
        basic_scraper.save_item()
        pending
      end

      it "deletes resized image" do
        basic_scraper.save_item()
        pending
      end
    end

  end

end