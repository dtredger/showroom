require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  # tell Devise which mapping should be used before a request. This is necessary because Devise
  # gets this information from the router, but since functional tests do not pass through the router,
  # it needs to be told explicitly. For example, if you are testing the user scope, simply do:
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { create(:user) }

  context "#show" do
    describe "authenticated user" do
      before do
        sign_in user
        get :show, id: user.id
      end

      it "returns users#show" do
        expect(response.status).to eq(200)
      end

      it "sets correct user" do
        get :show, id: user.id
        expect(current_user.id).to eq(user.id)
      end

      it "returns welcome message" do
        expect(request.response.flash).to eq("Welcome to Showspace")
      end
    end

    describe "un-authenticated user" do
      it "redirects" do
        expect(response).to redirect_to(user_session_path)
      end
    end

  end


  context "#edit" do
    describe "username" do
      it "updates username" do
        pending('soon...')
      end
    end

    describe "password" do
      it "updates password" do
        pending('soon')
      end
    end

  end


  context "#delete" do
    before(:each) do

    end

    describe "authenticated user" do

    end

    describe "un-authenticated user" do
      it "redirects" do
        expect(response).to redirect_to(user_session_path)
      end
    end

  end



end
