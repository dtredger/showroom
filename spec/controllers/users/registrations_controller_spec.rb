require 'rails_helper'

# ---------------- the following routes are built into devise, therefore untested here --------------------
#
#  # Session routes for Authenticatable (default)
#       new_user_session GET    /users/sign_in                    {controller:"devise/sessions", action:"new"}
#           user_session POST   /users/sign_in                    {controller:"devise/sessions", action:"create"}
#   destroy_user_session DELETE /users/sign_out                   {controller:"devise/sessions", action:"destroy"}
#
#  # Password routes for Recoverable, if User model has :recoverable configured
#      new_user_password GET    /users/password/new(.:format)     {controller:"devise/passwords", action:"new"}
#     edit_user_password GET    /users/password/edit(.:format)    {controller:"devise/passwords", action:"edit"}
#          user_password PUT    /users/password(.:format)         {controller:"devise/passwords", action:"update"}
#                        POST   /users/password(.:format)         {controller:"devise/passwords", action:"create"}
#
#
# --------------------------------------------------------------------------------------------------------

RSpec.describe Users::RegistrationsController, :type => :controller do
  # tell Devise which mapping should be used before a request. This is necessary because Devise
  # gets this information from the router, but since functional tests do not pass through the router,
  # it needs to be told explicitly. For example, if you are testing the user scope, simply do:
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    DatabaseCleaner.clean
  end

  let(:user) { create(:user) }
  let(:user2) { create(:user_2) }

  describe "#create" do
    describe "facebook" do

    end

    describe "email & p/w" do
      context "valid attributes" do
        it "saves user" do
          post :create, user: FactoryGirl.attributes_for(:user)
          expect( subject.current_user ).not_to be nil
        end
      end

      context "invalid attributes" do
        it "does not save" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          expect( subject.current_user ).to be nil
        end
      end
    end



  end

  describe "#destroy" do
    # TODO should there be a distinction btw/ authenticated & authorized?

    context "authenticated" do
      before { sign_in user }

      describe "DELETE" do
        before { delete :destroy }

        it "deletes user" do
          expect(User.find_by_id(user.id)).to be_nil
        end

        it "redirects to root" do
          expect(response).to redirect_to(root_path)
        end
      end

      # TODO do we want GET requests to delete users?
      describe "GET" do
        before { get :destroy }

        it "deletes user" do
          expect(User.find_by_id(user.id)).to be_nil
        end

        it "redirects to root" do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "unauthenticated" do
      before do
        sign_in user
        sign_out user
      end

      describe "DELETE" do
        before { delete :destroy }

        it "doesn't deletes user" do
          expect(User.find_by_id(user.id)).not_to be_nil
        end

        it "redirects to new session" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "GET" do
        before { get :destroy }

        it "doesn't deletes user" do
          expect(User.find_by_id(user.id)).not_to be_nil
        end

        it "redirects to new session" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end



  end



end
