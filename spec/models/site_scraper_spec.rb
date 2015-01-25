# == Schema Information
#
# Table name: site_scrapers
#
#  id                           :integer          not null, primary key
#  store_name                   :string
#  detail_product_name_selector :string
#  detail_description_selector  :string
#  detail_designer_selector     :string
#  detail_price_cents_selector  :string
#  detail_currency_selector     :string
#  detail_image_source_selector :string
#  index_product_link_selector  :string
#  detail_category_selector     :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  index_product_name_selector  :string
#  index_designer_selector      :string
#  index_category_selector      :string
#  index_item_group_selector    :string
#  index_price_cents_selector   :string
#  sku                          :string
#  page_urls                    :text
#

require 'rails_helper'

RSpec.describe SiteScraper, :type => :model do

  let(:scraper) { create(:site_scraper) }

  describe "#scrape_index" do
    it "is instance method" do
      expect(scraper).to respond_to(:scrape_index)
      expect(scraper.class).not_to respond_to(:scrape_index)
    end

    it "returns results array" do
      scrape_result = scraper.scrape_index(scraper.page_urls.first, is_test=true)
      expect(scrape_result).to be_a Array
    end

    context "three good rows" do
      before do
        @item_count = Item.count
        @result = scraper.scrape_index(scraper.page_urls.first, is_test=true)
      end

      it "creates three items" do
        expect(Item.count).to eq @item_count + 3
      end

      it "reports three successes" do
        expect(@result.first[:success]).to eq 3
      end

      it "logs success IDs" do
        item_ids = Item.all.map(&:id)
        expect(@result.second).to match_array item_ids
      end
    end

    context "items" do
      before { scraper.scrape_index(scraper.page_urls.first, is_test=true) }

      it "store name set" do
        all_stores = Item.all.map(&:store_name)
        expect(all_stores).to eq ["test", "test", "test"]
      end

      it "state incomplete" do
        all_states = Item.all.map(&:state)
        expect(all_states).to eq ["incomplete","incomplete","incomplete"]
      end
    end

  end

  describe "#scrape_detail_page" do
    it "is class method" do
      expect(scraper.class).to respond_to(:scrape_detail_page)
      expect(scraper).not_to respond_to(:scrape_detail_page)
    end

    context "sample item" do

      let(:incomplete_item) { create(:incomplete_item) }

      it "returns array" do
        detail_scrape = SiteScraper.scrape_detail_page(scraper, incomplete_item)
        expect(detail_scrape.class).to eq Array
      end

      context "item fields" do
        it "updates description" do
          expect{
            SiteScraper.scrape_detail_page(scraper, incomplete_item)
          }.to change { incomplete_item.description }
        end

        it "updates designer" do
          expect{
            SiteScraper.scrape_detail_page(scraper, incomplete_item)
          }.to change { incomplete_item.designer }
        end

        it "returns array" do
          @detail_scrape = SiteScraper.scrape_detail_page(scraper, incomplete_item)
          expect(@detail_scrape).to be_a Array
        end
      end
    end

  end

  describe "page_urls" do
    let(:scraper_with_multiple_urls) { create(:site_scraper, page_urls: "http://tres-bien.com/categories/outerwear/, http://tres-bien.com/categories/something-else/, http://tres-bien.com/categories/a-third-thing/")}

    it "splits urls" do
      expect(scraper_with_multiple_urls.page_urls).to be_a Array
      expect(scraper_with_multiple_urls.page_urls.length).to eq 3
    end
  end
end
