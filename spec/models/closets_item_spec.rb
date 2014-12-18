# == Schema Information
#
# Table name: closets_items
#
#  closet_id :integer
#  item_id   :integer
#

require 'rails_helper'

RSpec.describe ClosetsItem, :type => :model do

  let(:user) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user_2) }

  let(:item) { FactoryGirl.create(:item) }

  context "model" do
    it { is_expected.to respond_to(:closet_id) }
    it { is_expected.to respond_to(:item_id) }
  end

  describe "validations" do
    context "closet" do
      it "blank rejected" do
        no_closet = ClosetsItem.new(item_id: item.id, closet_id: nil)
        expect(no_closet).to have(1).errors_on(:closet_id)
      end
    end

    context "item" do
      it "blank rejected" do
        no_item = ClosetsItem.new(closet_id: user.closets.first.id, item_id: nil)
        expect(no_item).to have(1).errors_on(:item_id)
      end

      describe "duplicate" do
        context "same closet" do
          it "rejected" do
            closets_item_1 = FactoryGirl.create(:closets_item,
                closet_id: user.closets.first.id,
                item_id: item.id)
            duplicate = ClosetsItem.new(closet_id: user.closets.first.id, item_id: item.id)
            expect(duplicate).to have(1).errors_on(:item_id)
          end
        end

        context "different closet" do
          it "accepted" do
            FactoryGirl.create(:closet, user_id: user.id, title: "ONE")
            FactoryGirl.create(:closets_item, closet_id: user.closets.first.id,
                item_id: item.id)
            closets_item_1 = ClosetsItem.new(closet_id: user.closets.last.id,
                item_id: item.id)
            expect(closets_item_1).to be_valid
          end
        end
      end
    end
  end

end
