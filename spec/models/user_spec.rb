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
  
  let(:user) { create(:base_user) }


  context "model" do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:email) }

    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:encrypted_password) }
  end


  context "password" do
    describe "is blank" do
      before { user.password = user.password_confirmation = "" }
      it { is_expected.not_to be_valid }
    end

    describe "does not match confirmation" do
      before { user.password_confirmation = "different!" }
      it { is_expected.not_to be_valid }
    end
  end


  context "username" do
    describe "already exists" do
      let(:username_copy) { build(:base_user, email: 'something_else@email.co') }
      it { is_expected.not_to be_valid } 
      # it { is_expected.to have(1).errors_on(:username) }
    end

    describe "already exists in upper-case" do
      let(:upcase_username) { build(:base_user, username: base_user.username.upcase) }
      it { is_expected.not_to be_valid }
    end
  end


  context "email" do    
    describe "already taken" do
      let(:duplicate_user) { build(:base_user) }
      it { is_expected.not_to be_valid }
    end
  end


end