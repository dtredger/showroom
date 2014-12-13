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
  let!(:new_item) { FactoryGirl.create(:item) }

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

  context "check_for_duplicate" do
    describe "store, designer and name" do
      it "creates warning" do
        expect(new_item.duplicate_warnings.length).to eq(1)
      end

      it "attaches to new product" do
        expect(new_item.duplicate_warnings[0].pending_item_id).to eq(new_item.id)
      end

      it "refers to original" do
        expect(new_item.duplicate_warnings[0].existing_item_id).to eq(original_item.id)
      end

      describe "#delete_duplicate_warnings" do
        context "destroy pending item" do
          it "deletes warning" do
            new_item.destroy
            expect(DuplicateWarning.find_by(existing_item_id: original_item)).to be_nil
            expect(DuplicateWarning.find_by(pending_item_id: new_item)).to be_nil
          end
        end

        context "destroy existing item" do
          it "deletes warning" do
            original_item.destroy
            expect(DuplicateWarning.find_by(existing_item_id: original_item)).to be_nil
            expect(DuplicateWarning.find_by(pending_item_id: new_item)).to be_nil
          end
        end
      end

    end
  end

end


  #
  # perform_item_management_operation
  # handle_state
  # add_duplicate_warning
  # remove_duplicate_warning
  # delete_duplicate_warnings
  # check_for_duplicate
