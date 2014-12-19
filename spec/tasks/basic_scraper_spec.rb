
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
        VCR.use_cassette('valid_url') do
          site = basic_scraper.open_url(VALID_URL)
          expect(site.class).to eq(Nokogiri::HTML::Document)
        end
      end
    end

    describe "bad url" do
      it "raises error" do
        expect{
          basic_scraper.open_url('a bad url!')
        }.to raise_error(TypeError)
      end
    end
  end


  context "#get_image" do
    describe "url not valid image" do
      it "returns ImageMagickError" do
        VCR.use_cassette('valid_url') do
          expect{
            basic_scraper.get_image(VALID_URL)
          }.to raise_error(Magick::ImageMagickError)
        end
      end
    end

    describe "valid url" do
      it "returns file" do
        puts "TODO - cassette not compatible with image"
        VCR.use_cassette('valid_image_url') do
          file = basic_scraper.get_image(VALID_IMAGE_URL)
          expect(file).to be_kind_of(Magick::Image)
        end
      end
    end
  end


  context "#resize_image" do
    describe "no img format" do
      it "raises error" do
        magick_image = Magick::Image.new(100,100)
        expect{
          basic_scraper.resize_image(magick_image)
        }.to raise_error(NoMethodError)
      end

      it "does not create file" do
        magick_image = Magick::Image.new(100,100)
        expect{
          begin
            basic_scraper.resize_image(magick_image)
          rescue
            nil
          end
        }.not_to change{ Dir[IMAGE_FILE_LOCATION].count }
      end
    end

    describe "success" do
      it "returns new file" do
        magick_image = Magick::Image.new(100,100) { self.format = "JPEG" }
        response = basic_scraper.resize_image(magick_image)

        expect(File.exist? response).to be_truthy
      end
    end

    after do
      Dir[Rails.root.join('public/img/*.*')].each { |f| File.delete f }
    end
  end


  context "#save_item_from_url" do
    describe "failure" do
      bad_item = FactoryGirl.create(:item)
      bad_item[images: 'invalid!']

      it("returns error") { expect { Item.create(item) }.to raise_exception }
    end

    describe "success" do
      item_attributes_with_images = FactoryGirl.attributes_for(:item)
      item_attributes_with_images[images: SAMPLE_IMAGE_PATH]
      result = basic_scraper.save_item_from_url(item_attributes_with_images)

      it("returns saved item") { expect(result.class).to eq(Item) }
    end

    after do
      Dir[Rails.root.join('public/img/*.*')].each { |f| File.delete f }
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