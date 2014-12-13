
require 'rails_helper'
require Rails.root.join('lib/tasks/BasicScraper.rb')

RSpec.describe 'Basic Scraper' do

  VALID_URL = "https://www.google.ca"
  VALID_IMAGE_URL = "http://placekitten.com/g/200/200"
  SAMPLE_IMAGE_PATH = "#{Rails.root}/public/images/doge_log.gif"
  IMAGE_FILE_LOCATION = "#{Rails.root}/public/img"
  basic_scraper = BasicScraper.new

  context "#open_url" do
    describe "valid url" do
      it "fetches DOM" do
        VCR.use_cassette('valid_url')do
          site = basic_scraper.open_url(VALID_URL)
          expect(site.class).to eq(Nokogiri::HTML::Document)
        end
      end
    end

    describe "bad url" do
      it "returns error" do
        response = basic_scraper.open_url('a bad url!')
        expect(response).to eq('Open_url Error: No such file or directory - a bad url!')
      end
    end
  end


  context "#get_image" do
    describe "invalid url" do
      it "returns general error" do
        file = basic_scraper.get_image "bogus!"
        expect(file).to eq("get_image error: No such file or directory - bogus!")
      end
    end

    describe "url not image" do
      it "returns ImageMagickError" do
        VCR.use_cassette('valid_url') do
          file = basic_scraper.get_image VALID_URL
          expect(file).to eq("get_image ImageMagickError: bad image format - #{VALID_URL}")
        end
      end
    end

    describe "valid url" do
      it "returns file" do
        VCR.use_cassette('valid_image_url') do
          file = basic_scraper.get_image VALID_IMAGE_URL
          expect(file).to be_kind_of(Magick::Image)
        end
      end
    end
  end


  context "#resize_image" do
    describe "failure" do
      it "returns error" do
        magick_image = Magick::Image.new(100,100)
        response = basic_scraper.resize_image(magick_image)

        expect(response).to eq("resize_image error: undefined method `downcase' for nil:NilClass")
      end

      it "does not create file" do
        magick_image = Magick::Image.new(100,100)
        response = basic_scraper.resize_image(magick_image)

        expect(File.exist? response).to be_falsey
      end
    end

    describe "success" do
      it "returns new file" do
        magick_image = Magick::Image.new(100,100) { self.format = "JPEG" }
        response = basic_scraper.resize_image(magick_image)

        expect(File.exist? response).to be_truthy
      end
    end

    after(:all) do
      Dir[Rails.root.join('public/img/*.*')].each { |f| File.delete f }
    end
  end


  context "#save_item_from_url" do
    # describe "failure" do
    #   bad_item = FactoryGirl.create(:item, image_source: 'trrble')
    #
    #   it "returns error" do
    #     expect{Item.create(item)}.to raise_exception
    #   end
    # end

    describe "success" do
      item_attributes = FactoryGirl.attributes_for(:item, image_source: VALID_IMAGE_URL)
      result = basic_scraper.save_item_from_url(item_attributes)

      it "returns saved item" do
        expect(result.class).to eq(Item)
      end

      it "deletes resized image" do
        expect(File.exist? result.image_source.path).to be_falsey
      end
    end

  end

  context "#price_to_cents" do
    describe "non-price" do
      it "returns error" do
        expect{ basic_scraper.price_to_cents('not a price') }.to raise_exception
      end
    end

    describe "number price" do
      it "parses prices without cents" do
        price = basic_scraper.price_to_cents(159.90)
        expect(price).to eq(15990)
      end

      it "parses string price with $ and ," do
        price = basic_scraper.price_to_cents("$1,129.30")
        expect(price).to eq(112930)
      end
    end

  end

end