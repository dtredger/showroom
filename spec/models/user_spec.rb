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
#  slug                   :string(255)      not null
#

require "rails_helper"

describe User do

  let!(:user) { FactoryGirl.create(:user) }

  context "model" do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:encrypted_password) }
  end

  context "validations" do
    describe "password" do
      context "is blank" do
        user_without_password = FactoryGirl.build(:user_2, password: "", password_confirmation: "")
        it { expect(user_without_password).not_to be_valid }

        it "gives password error" do
          expect(user_without_password).to have(1).errors_on(:password)
        end

      end

      context "does not match confirmation" do
        password_confirm_mismatch = FactoryGirl.build(:user_2, password_confirmation: "different!")
        it { expect(password_confirm_mismatch).not_to be_valid }

        it "gives confirmation error" do
          expect(password_confirm_mismatch).to have(1).errors_on(:password_confirmation)
        end
      end
    end

    describe "username" do
      context "already exists" do
        let(:username_copy) { FactoryGirl.build(:unique_user, username: user[:username]) }
        it { expect(username_copy).not_to be_valid }
        it { expect(username_copy).to have(1).errors_on(:username) }
      end

      context "already exists in upper-case" do
        let(:upcase_username ) { FactoryGirl.build(:user_2, username: "username".upcase) }
        it { expect(upcase_username).not_to be_valid }
        it { expect(upcase_username).to have(1).errors_on(:username) }
      end

      context "blank" do
        let(:username_blank ) { FactoryGirl.create(:user_2, username: "") }
        it { expect(username_blank).to be_valid }
        it("defaults to email") { expect(username_blank[:username]).to eq(username_blank[:email]) }
      end
    end

    describe "email" do
      context "already taken" do
        let(:duplicate_email) { FactoryGirl.build(:user_2, email: "user@email.com") }
        it { expect(duplicate_email).not_to be_valid }
        it { expect(duplicate_email).to have(1).errors_on(:email) }
      end
    end
  end

  context "callbacks" do
    describe "#make_a_closet" do
      let(:new_user) { FactoryGirl.create(:unique_user) }
      it "creates default closet for new user" do
        expect(new_user.closets.count).to eq(1)
      end
    end

    describe "#find_first_by_auth_conditions" do
      context "blank login" do
        it "returns none" do
          warden_conditions = { login: "" }
          found = User.find_first_by_auth_conditions(warden_conditions)
          expect(found).to eq(nil)
        end
      end

      context "unknown login" do
        it "returns none" do
          warden_conditions = { login: "bogus!" }
          found = User.find_first_by_auth_conditions(warden_conditions)
          expect(found).to eq(nil)
        end
      end

      context "email login" do
        it "returns user" do
          warden_conditions = { login: user.email }
          found = User.find_first_by_auth_conditions(warden_conditions)
          expect(found).to be_a(User)
        end
      end

      context "username login" do
        it "returns user" do
          warden_conditions = { login: user.username }
          found = User.find_first_by_auth_conditions(warden_conditions)
          expect(found).to be_a(User)
        end
      end
    end

    describe "#update_facebook_info" do
      mock_auth = {credentials: {
          token: "TOKEN_OAUTH_2", expires_at: 1321747205} }

      it "saves fb token to user" do
        user.update_facebook_info(mock_auth)
        expect(user.fb_token).to eq("TOKEN_OAUTH_2")
      end
    end

    describe "#create_username" do
      context "username exists" do
        let(:new_user) { FactoryGirl.build(:unique_user, username: "valid") }
        it "does not alter" do
          new_user.create_username
          expect(new_user[:username]).to eq("valid")
        end
      end

      context "username nil" do
        let(:new_user) { FactoryGirl.build(:unique_user, email: "test@e.co", username: "") }
        it "set email as username" do
          new_user.create_username
          expect(new_user[:username]).to eq("test@e.co")
        end
      end
    end
  end

  context "slugs" do
    describe "no slug conflict" do
      let(:no_conflict_user) { FactoryGirl.create(:unique_user, username: 'something cool') }
      it "parameterizes username" do
        expect(no_conflict_user[:slug]).to eq("something-cool")
      end
    end

    describe "slug conflict" do
      it "uses email as fallback" do
        user1 = FactoryGirl.create(:unique_user, email: "user1@email.com", username: 'name taken')
        user2 = FactoryGirl.create(:unique_user, email: "second@email.com", username: 'name-taken')
        expect(user2[:slug]).to eq("second-email-com")
      end
    end
  end
end
