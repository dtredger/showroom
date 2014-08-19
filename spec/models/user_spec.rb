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

  before(:all) do
    @user = FactoryGirl.create(:user)
  end

  context "model" do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:encrypted_password) }
  end

  context "password" do
    describe "is blank" do
      user_without_password = FactoryGirl.build(:user_2, password: "", password_confirmation: "")
      it { expect(user_without_password).not_to be_valid }

      it "gives password error" do
        expect(user_without_password.errors_on(:password).size).to eq(1)
      end

    end

    describe "does not match confirmation" do
      password_confirmation_mismatch = FactoryGirl.build(:user_2, password_confirmation: "different!")
      it { expect(password_confirmation_mismatch).not_to be_valid }

      it "gives confirmation error" do
        expect(password_confirmation_mismatch.errors_on(:password_confirmation).size).to eq(1)
      end
    end

  end

  context "username" do
    describe "already exists" do
      username_copy = FactoryGirl.build(:user_2, username: 'username')
      it { is_expected.not_to be_valid }

      it "gives username error" do
        expect(username_copy.errors_on(:username).size).to eq(1)
      end
    end

    describe "already exists in upper-case" do
      upcase_username = FactoryGirl.build(:user_2, username: "username".upcase)
      it { expect(upcase_username).not_to be_valid }

      it "gives username error" do
        expect(upcase_username.errors_on(:username).size).to eq(1)
      end
    end

  end

  context "email" do
    describe "already taken" do
      duplicate_email = FactoryGirl.build(:user_2, email: 'user@email.com')
      it { expect(duplicate_email).not_to be_valid }

      it "gives email error" do
        expect(duplicate_email.errors_on(:email).size).to eq(1)
      end
    end

  end

end