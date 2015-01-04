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
# --------------------------------------------------------------------------------------------------------

RSpec.describe Users::RegistrationsController, :type => :controller do

  # tell Devise which mapping should be used before a request. This is necessary because Devise
  # gets this information from the router, but since functional tests do not pass through the router,
  # it needs to be told explicitly. For example, if you are testing the user scope, simply do:
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { create(:user) }
  let(:user2) { create(:user_2) }
  let(:unique_user) { create(:unique_user) }


  describe "#new" do
    it "builds empty User" do
      get :new
      expect(assigns[:user][:email]).to eq("")
    end

    it "clears FB session" do
      session[:fb_uid] = "1000"
      session[:fb_token] = "SOMEtOKeN"
      session[:fb_token_expiration] = 1421747205
      get :new
      expect(session).to be_empty
    end

    # TODO - why does #new clear session?
  end

  describe "#create" do
    describe "email & p/w" do
      context "invalid attributes" do
        it "does not save user" do
          expect{
            post :create, user: FactoryGirl.attributes_for(:invalid_user)
          }.to change{User.count}.by(0)
        end

        it "does not log in user" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          expect(subject.current_user).to be nil
        end

        it "renders #new" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          expect(response).to render_template(:new)
        end
      end

      context "valid attributes" do
        it "saves user" do
          expect{
            post :create, user: FactoryGirl.attributes_for(:unique_user)
          }.to change{User.count}.by(1)
        end

        it "logs user in" do
          post :create, user: FactoryGirl.attributes_for(:user_2, email: "some-kinda@email.co")
          expect(subject.current_user.email).to eq("some-kinda@email.co")
        end

        it "redirects to root" do
          post :create, user: FactoryGirl.attributes_for(:unique_user)
          # TODO alter after_sign_up_path_for to direct somewhere else
          expect(response).to redirect_to(root_path)
        end

        it "flashes welcome" do
          post :create, user: FactoryGirl.attributes_for(:unique_user)
          expect(flash[:notice]).to eq("Welcome! You have signed up successfully.")
        end

        it "sends new_user email" do
          post :create, user: FactoryGirl.attributes_for(:unique_user, email: "an@email.co")
          expect(ActionMailer::Base.deliveries.last.to).to eq(["an@email.co"])
        end
      end
    end

    pending "facebook" do
      context "invalid oauth" do
        before(:each) do
          session[:fb_uid] = ""
          session[:fb_token] = ""
          session[:fb_token_expiration] = nil
          post :create, user: FactoryGirl.attributes_for(:unique_user)
        end

        it "clears fb from session" do
          expect(session.keys.grep(/^fb_/)).to be_empty
        end

        it "renders #new" do
          expect(response).to render_template(:new)
        end

        it "does not save fb credentials" do
          expect(User.find(user.id).fb_uid).to be_nil
          expect(User.find(user.id).fb_token).to be_nil
          expect(User.find(user.id).fb_token_expiration).to be_nil
        end
      end

      context "valid oauth" do
        before(:each) do
          User.delete_all
          session[:fb_uid] = "12345678"
          session[:fb_token] = "TOKEN2"
          session[:fb_token_expiration] = 1421747205
          post :create, user: FactoryGirl.attributes_for(:user)
        end

        it "saves user fb credentials" do
          expect(User.find(user.id).fb_uid).to eq("12345678")
          expect(User.find(user.id).fb_token).to eq("TOKEN2")
          expect(User.find(user.id).fb_token_expiration).to eq(1421747205)
        end

        it "logs user in" do
          expect(subject.current_user).not_to be nil
        end

        it "redirects to root" do
          # TODO alter after_sign_up_path_for to direct somewhere else?
          expect(response).to redirect_to(root_path)
        end

        it "flashes welcome" do
          expect(flash[:notice]).to eq("Welcome! You have signed up successfully.")
        end

        it "clears fb from session" do
          expect(session.keys.grep(/^fb_/)).to be_empty
        end
      end
    end
  end

  describe "#edit" do
    context "authorized user" do
      it "renders #edit" do
        sign_in user
        get :edit
        expect(response).to render_template(:edit)
      end
    end

    context "un-authenticated user" do
      it "redirects to login" do
        get :edit
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#update" do
    context "unauthorized user" do
      before do
        sign_in user2
        put :update, user: FactoryGirl.attributes_for(:user,
          email: "something@new.co",
          username: "something_else",
          current_password: "user_password")
      end

      it "does not update target user" do
        expect(user.username).to eq("username")
      end

      it "does not update own user" do
        expect(user2.username).not_to eq("something_else")
      end
    end

    context "un-authenticated user" do
      before do
        put :update, user: FactoryGirl.attributes_for(:user,
          email: "something@new.co",
          username: "something else",
          current_password: "user_password")
      end

      it "does not update user" do
        expect(user.username).to eq("username")
      end
    end

    context "authorized user" do
      before { sign_in user }

      it "updates username" do
        put :update,
            id: user.id,
            user: FactoryGirl.attributes_for(:user,
              email: "somethingelse@email.com",
              username: "something else",
              current_password: "user_password")
        user.reload
        expect(user.email).to eq("somethingelse@email.com")
      end
    end
  end

  describe "#destroy" do
    # TODO - should there be a distinction btw/ authenticated & authorized?
    # TODO - deleting account is currently not accessible anywhere in UI

    context "authenticated" do
      before { sign_in user }

      describe "DELETE" do
        it "reduces user count" do
          expect{
            delete :destroy
          }.to change{User.count}.by(-1)
        end

        it "deletes user" do
          delete :destroy
          expect(User.find_by_id(user.id)).to be_nil
        end

        it "redirects to root" do
          delete :destroy
          expect(response).to redirect_to(root_path)
        end
      end

      # TODO do we want GET requests to delete users?
      describe "GET" do
        it "reduces user count" do
          expect{
            get :destroy
          }.to change{User.count}.by(-1)
        end

        it "deletes user" do
          get :destroy
          expect(User.find_by_id(user.id)).to be_nil
        end

        it "redirects to root" do
          get :destroy
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "unauthenticated" do
      describe "DELETE" do
        before { delete :destroy }

        it "doesn't delete user" do
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

    context "unauthorized" do
      it "doesn't delete target user" do
        sign_in user
        delete :destroy, id: user2.id
        expect(User.find_by_id(user2.id)).not_to be_nil
      end

      it "deletes own user" do
        sign_in user
        delete :destroy, id: user2.id
        expect(User.find_by_id(user.id)).to be_nil
      end
    end

  end

  pending "facebook_confirmation" do
    #TODO test that the fb info is passed to the sign-up form correctly
    before do
      session[:fb_uid] = 12421
      session[:fb_token] = "Some Token"
      session[:fb_token_expiration] = 1420102012
      redirect_to update_user_facebook_confirmation_path
    end

    it "renders facebook_confirmation" do
      expect(response).to render_template(:facebook_confirmation)
    end

    it "fb info in session" do
      expect(session.keys.grep(/^fb_/).length).to eq(3)
    end

  end


end
