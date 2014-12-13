# == Schema Information
#
# Table name: duplicate_warnings
#
#  id               :integer          not null, primary key
#  pending_item_id  :integer
#  existing_item_id :integer
#  warning_notes    :text
#  created_at       :datetime
#  updated_at       :datetime
#  match_score      :integer
#

require 'rails_helper'

RSpec.describe DuplicateWarning, :type => :model do

  let(:item_1) { FactoryGirl.create(:unique_item) }
  let(:item_2) { FactoryGirl.create(:unique_item) }

  context "model" do
    it { is_expected.to respond_to(:existing_item_id) }
    it { is_expected.to respond_to(:pending_item_id) }
    it { is_expected.to respond_to(:warning_notes) }
    it { is_expected.to respond_to(:match_score) }
  end

  describe "validations" do
    context "pending_item" do
      it "blank rejected" do
        no_pending = DuplicateWarning.new(existing_item_id: item_1.id,
            pending_item_id: nil)
        expect(no_pending).to have(1).errors_on(:pending_item_id)
      end
    end

    context "existing_item" do
      it "blank rejected" do
        no_existing = DuplicateWarning.new(pending_item_id: item_1.id,
            existing_item_id: nil)
        expect(no_existing).to have(1).errors_on(:existing_item_id)
      end
    end

    # fails because of ActiveRecord::RecordNotUnique: PG::UniqueViolation
    # not model validation
    context "duplicate" do
      it "rejected" do
        duplicate_warning_1 = FactoryGirl.create(:duplicate_warning,
            pending_item_id: item_1.id,
            existing_item_id: item_2.id)
        duplicate = DuplicateWarning.create(pending_item_id: item_1.id,
            existing_item_id: item_2.id)
        expect(duplicate).to have(1).errors_on(:pending_item_id)
      end
    end

  end

end
