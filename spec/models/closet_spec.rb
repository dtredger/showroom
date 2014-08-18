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

  let(:user) { create(:user) }

  context "model" do
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:summary) }

    it { is_expected.to respond_to(:user_id) }
  end

  context "created with new user" do
    it { expect(user.closets).not_to be_empty }
  end

  context "naming" do
    describe "same user" do
      it "rejects duplicate title" do
        duplicate_closet_title = Closet.create(user_id: user.id, title: "My Closet", summary: "new closet summary")
        expect(duplicate_closet_title).not_to be_valid
      end

      it "rejects duplicate summary" do
        duplicate_closet_summary = Closet.create(user_id: user.id, title: "New Title", summary: "My first closet")
        expect(duplicate_closet_summary).not_to be_valid
      end
    end

    describe "different user" do
      it "accepts duplicate title" do
        duplicate_closet_title = Closet.create(user_id: user.id, title: "My Closet", summary: "new closet summary")
        expect(duplicate_closet_title).to be_valid
      end

      it "accepts duplicate summary" do
        duplicate_closet_summary = Closet.create(user_id: user.id, title: "New Title", summary: "My first closet")
        expect(duplicate_closet_summary).to be_valid
      end
    end
  end


  context "item" do
    describe "duplicates" do

      it "rejects duplicates" do
        pending('desirable?')
      end



    end
  end


  end
