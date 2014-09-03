require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, :type => :controller do

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  context "facebook" do
    describe "sign up" do
      before { get :user_omniauth_authorize_path , provider: :facebook }

      it "sets fb session" do
        expect(session.keys.grep(/^fb_/).length).to eq(3)
      end

      it "redirects to users#facebook_confirmation" do
        expect(response).to redirect_to(update_user_facebook_confirmation_path)
      end
    end

    describe "sign in" do
      context "account not linked" do
        pending
      end

      context "account already linked" do
        it "updates fb token expiry" do
          expect(current_user.fb_token_expiration).to eq(mock_auth[:facebook].fb_token_expiration)
        end

        it "signs in user" do
          pending
          expect(current_user.id).to eq('cats')
        end
      end
    end

  end

end
