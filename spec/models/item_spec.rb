# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  product_name :text
#  description  :text
#  designer     :text
#  price_cents  :integer
#  currency     :string(255)
#  store_name   :string(255)
#  product_link :text
#  category1    :string(255)
#  category2    :string(255)
#  category3    :string(255)
#  state        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  sku          :string(255)
#

require "rails_helper"

RSpec.describe Item, :type => :model do

  let!(:original_item) { FactoryGirl.create(:item) }

  context "model" do
    it { is_expected.to respond_to(:product_name) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:designer) }
    it { is_expected.to respond_to(:price_cents) }
    it { is_expected.to respond_to(:currency) }
    it { is_expected.to respond_to(:store_name) }
    it { is_expected.to respond_to(:product_link) }
    # TODO - move to category as array
    # https://www.amberbit.com/blog/2014/2/4/postgresql-awesomeness-for-rails-developers/
    it { is_expected.to respond_to(:category1) }
    it { is_expected.to respond_to(:category2) }
    it { is_expected.to respond_to(:category3) }
    it { is_expected.to respond_to(:state) }
    it { is_expected.to respond_to(:sku) }
  end

  describe "#check_for_duplicate" do
    context "different store" do
      it "does not create warning" do
        new_item = FactoryGirl.create(:item, store_name: "something else")
        expect(new_item.duplicate_warnings).to be_empty
      end
    end

    context "same store" do
      describe "identical items" do
        let!(:new_item) { FactoryGirl.create(:item) }
        it("creates duplicate_warning") { expect(new_item.duplicate_warnings.length).to eq(1) }
        it("assigns match_score 330") { expect(new_item.duplicate_warnings.first[:match_score]).to eq(330) }
        it "warning_notes reference fields" do
          expect(new_item.duplicate_warnings.first[:warning_notes]).to eq("sku, product_link, product_name, price, designer, category")
        end
      end

      describe "unique items" do
        it "does not create warning" do
          new_item = FactoryGirl.create(:item_1_store)
          expect(new_item.duplicate_warnings).to be_empty
        end
      end

      context "major match criteria" do
        describe "sku match" do
          let(:new_item) { FactoryGirl.create(:item_1_store, sku: "item_one sku") }
          it { expect(new_item.duplicate_warnings.length).to eq(1) }
          it { expect(new_item.duplicate_warnings.first[:match_score]).to eq(100) }
          it { expect(new_item.duplicate_warnings.first[:warning_notes]).to eq("sku") }
        end

        describe "product_link match" do
          let(:new_item) { FactoryGirl.create(:item_1_store, product_link: "http://item_one-link") }
          it { expect(new_item.duplicate_warnings.length).to eq(1) }
          it { expect(new_item.duplicate_warnings.first[:match_score]).to eq(90) }
          it { expect(new_item.duplicate_warnings.first[:warning_notes]).to eq("product_link") }
        end

        describe "product_name match" do
          let(:new_item) { FactoryGirl.create(:item_1_store, product_name: "item_one product name") }
          it { expect(new_item.duplicate_warnings.length).to eq(1) }
          it { expect(new_item.duplicate_warnings.first[:match_score]).to eq(70) }
          it { expect(new_item.duplicate_warnings.first[:warning_notes]).to eq("product_name") }
        end
      end

      context "minor match criteria" do
        describe "designer match" do
          it "does not create warning" do
            new_item = FactoryGirl.create(:item_1_store, designer: "item_one designer")
            expect(new_item.duplicate_warnings).to be_empty
          end
        end

        describe "price match" do
          it "does not create warning" do
            new_item = FactoryGirl.create(:item_1_store, price_cents: 100)
            expect(new_item.duplicate_warnings).to be_empty
          end
        end

        describe "category match" do
          it "does not create warning" do
            new_item = FactoryGirl.create(:item_1_store, category1: "item_one category")
            expect(new_item.duplicate_warnings).to be_empty
          end
        end

        context "multiple matches" do
          describe "designer, price, and category match" do
            let(:new_item) do
              FactoryGirl.create(:item_1_store,
                  designer: "item_one designer",
                  price_cents: 100,
                  category1: "item_one category")
            end
            it { expect(new_item.duplicate_warnings.length).to eq(1) }
            it("sums match score") { expect(new_item.duplicate_warnings.first[:match_score]).to eq(70) }
            it { expect(new_item.duplicate_warnings.first[:warning_notes]).to eq("price, designer, category") }
          end
        end
      end

    end

  end

  describe "#delete_duplicate_warnings" do
    context "single warning" do
      describe "destroy pending item" do

        it "deletes warning" do
          new_item = FactoryGirl.create(:item)
          new_item.destroy
          expect(DuplicateWarning.find_by(existing_item_id: original_item)).to be_nil
          expect(DuplicateWarning.find_by(pending_item_id: new_item)).to be_nil
        end
      end

      describe "destroy existing item" do
        it "deletes warning" do
          new_item = FactoryGirl.create(:item)
          original_item.destroy
          expect(DuplicateWarning.find_by(existing_item_id: original_item)).to be_nil
          expect(DuplicateWarning.find_by(pending_item_id: new_item)).to be_nil
        end
      end
    end

    context "multiple warnings" do
      before do
        new_item = FactoryGirl.create(:item)
        new_item_2 = FactoryGirl.create(:item)
        # new_item_2 will create two new warnings:
        # new_item_2 will be pending_item for both;
        # existing_item will be original_item (1) and new_item (1)
      end

      it "creates two new warnings" do
        expect(DuplicateWarning.count).to eq(3)
      end

      describe "destroy pending & existing" do
        it "deletes pending_item warnings" do
          new_item = FactoryGirl.create(:item)
          new_item_2 = FactoryGirl.create(:item)
          new_item.destroy
          expect(DuplicateWarning.find_by(pending_item_id: new_item.id)).to be_nil
        end

        it "deletes existing_item warnings" do
          new_item = FactoryGirl.create(:item)
          new_item_2 = FactoryGirl.create(:item)
          new_item.destroy
          expect(DuplicateWarning.find_by(existing_item_id: new_item.id)).to be_nil
        end
      end
    end
  end


  describe "#monetize" do
    pending
  end

  describe "#perform_item_management_operation" do
    pending
  end



end

