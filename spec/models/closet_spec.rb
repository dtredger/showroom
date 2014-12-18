# == Schema Information
#
# Table name: closets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  summary    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Closet, :type => :model do

  let(:user) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user_2) }

  context "model" do
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:summary) }
    it { is_expected.to respond_to(:user_id) }
  end

  describe "new user" do
    it "has default closet" do
      expect(user.closets.length).to eq(1)
    end
  end

  describe "validations" do
    context "title" do
      it "blank rejected" do
        blank = user.closets.build(title:'')
        expect(blank).to have(1).errors_on(:title)
      end

      describe "uniqueness" do
        context "same user" do
          it "duplicate rejected" do
            duplicate = user.closets.build(title: "My Closet", summary: "same title as default")
            expect(duplicate).to have(1).errors_on(:title)
          end

          it "uppercase also rejected" do
            upper_duplicate = user.closets.build(title: "mY CLOSeT", summary: "only case different")
            expect(upper_duplicate).to have(1).errors_on(:title)
          end
        end

        context "different user" do
          it "accepts duplicate title" do
            expect{
              user.closets.build(title: "ONE")
              user_2.closets.build(title: "ONE")
            }.to change{Closet.count}.by(2)
          end
        end
      end
    end

    context "user" do
      it "rejects nil" do
        no_user = FactoryGirl.build(:closet, user_id: nil)
        expect(no_user).not_to be_valid
        expect(no_user).to have(1).errors_on(:user)
      end

      it "rejects invalid user" do
        user_2.destroy
        no_user = FactoryGirl.build(:closet, user_id: user_2.id)
        expect(no_user).not_to be_valid
        expect(no_user).to have(1).errors_on(:user)
      end
    end
  end

end
