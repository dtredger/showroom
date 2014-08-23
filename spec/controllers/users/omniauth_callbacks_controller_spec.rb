require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, :type => :controller do

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  context "facebook" do
    describe "sign up" do
      pending
    end

    describe "sign in" do
      describe "account already linked" do
        pending
      end

      describe "account not linked" do
        pending
      end

    end
  end

end
