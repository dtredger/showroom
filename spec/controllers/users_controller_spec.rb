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

RSpec.describe UsersController, :type => :controller do
  # tell Devise which mapping should be used before a request. This is necessary because Devise
  # gets this information from the router, but since functional tests do not pass through the router,
  # it needs to be told explicitly. For example, if you are testing the user scope, simply do:
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { create(:user) }
  let(:user2) { create(:user_2) }

  context "#show" do
    describe "authorized user" do
      before do
        sign_in user
        get :show, id: user.id
      end

      it { expect(response.status).to eq(200) }

      it "sets correct user" do
        expect(subject.current_user.id).to eq(user.id)
      end
    end

    describe "unauthorized user" do
      before do
        sign_in user2
        get :show, id: user.id
      end

      it "redirects to their #show" do
        expect(response).to redirect_to(user_path user2)
      end

      it "flashes login notice" do
        expect(flash[:alert]).to eq("Please log in")
      end
    end

    describe "un-authenticated user" do
      before { get :show, id: user.id }

      it "redirects to login" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "flashes login notice" do
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end



  end


  # context "#edit" do
  #   describe "username" do
  #     it "updates username" do
  #       pending('soon...')
  #     end
  #   end
  #
  #   describe "password" do
  #     it "updates password" do
  #       pending('soon')
  #     end
  #   end
  #
  # end


  # context "#delete" do
  #   before(:each) do
  #
  #   end
  #
  #   describe "authenticated user" do
  #
  #   end
  #
  #   describe "un-authenticated user" do
  #     it "redirects" do
  #       expect(response).to redirect_to(user_session_path)
  #     end
  #   end
  #
  # end



end
