# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  fb_uid                 :string(255)
#  fb_token               :string(255)
#  fb_token_expiration    :datetime
#  username               :string(255)
#

require 'rails_helper'


describe User do

  context "model" do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:email) }

    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:encrypted_password) }
  end


  context "password" do
    describe "is blank" do
      user_without_password = FactoryGirl.build(:user, password: "", password_confirmation: "")
      it { expect(user_without_password).not_to be_valid }
    end

    describe "does not match confirmation" do
      confirmation_mismatch_user = FactoryGirl.build(:user, password_confirmation: "different!")
      it { expect(confirmation_mismatch_user).not_to be_valid }
    end
  end


  context "username" do
    let(:user) { create(:user) }

    describe "already exists" do
      let(:username_copy) { build(:user, email: 'something_else@email.co') }
      it { is_expected.not_to be_valid }
      it { expect(username_copy.errors[:username].first).to eq("has already been taken") }
    end

    describe "already exists in upper-case" do
      let(:upcase_username) { build(:user, email: "different@mail.co", username: "username".upcase) }
      it { expect(upcase_username).not_to be_valid }
      it { expect(upcase_username.errors[:username].first).to eq("has already been taken") }
    end
  end


  context "email" do
    describe "already taken" do
      let(:duplicate_email) { build(:user, username: 'something_else') }
      it { expect(duplicate_email).not_to be_valid }
    end
  end


end