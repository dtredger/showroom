# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  product_name       :text
#  description        :text
#  designer           :text
#  price_cents        :integer
#  currency           :string(255)
#  store_name         :string(255)
#  image_source       :text
#  image_source_array :text
#  product_link       :text
#  category1          :string(255)
#  category2          :string(255)
#  category3          :string(255)
#  state              :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require "rails_helper"

RSpec.describe Item, :type => :model do

  before(:all) do
    Item.delete_all
  end

  let(:item_1) { create(:item) }

  context "model" do
    it { is_expected.to respond_to(:product_name) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:designer) }
    it { is_expected.to respond_to(:price_cents) }
    it { is_expected.to respond_to(:currency) }
    it { is_expected.to respond_to(:store_name) }
    it { is_expected.to respond_to(:image_source) }
    it { is_expected.to respond_to(:image_source_array) }
    it { is_expected.to respond_to(:product_link) }
    it { is_expected.to respond_to(:category1) }
    it { is_expected.to respond_to(:category2) }
    it { is_expected.to respond_to(:category3) }
    it { is_expected.to respond_to(:state) }
  end

  context "matches" do
    describe "store, designer and name" do
      item_1 = FactoryGirl.create(:item)
      item_2 = FactoryGirl.create(:item)

      it "creates warning" do
        expect(item_2.duplicate_warnings.length).to eq(1)
      end

      it "attaches to new product" do
        expect(item_2.duplicate_warnings[0].pending_item_id).to eq(item_2.id)
      end

      it "refers to original" do
        expect(item_2.duplicate_warnings[0].existing_item_id).to eq(item_1.id)
      end
    end
  end

  context "images" do
    describe "image_source" do
      it "names image with filename" do
        expect(item_1["image_source"]).to eq("doge_log.gif")
      end

      it "formats path with attributes" do
        expect(item_1.image_source.url).to eq("/items/a_store_na/designer_test/Test_Produ/doge_log.gif")
      end

      it "stores CarrierWave file" do
        expect(item_1.image_source.file.class.to_s).to eq("CarrierWave::SanitizedFile")
      end
    end
  end

end
