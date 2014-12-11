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

  describe "#show" do
    context "authorized user" do
      before do
        sign_in user
        get :show
      end

      it { expect(response.status).to eq(200) }
      it("sets correct user") { expect(subject.current_user.id).to eq(user.id) }
    end

    context "unauthorized user" do

      pending('what do we want in this case?')
      # before do
      #   sign_in user2
      #   get :show, id: user.id
      # end
      #
      # it "redirects to their #show" do
      #   expect(response).to redirect_to(user_path user2)
      # end
      #
      # it "flashes login notice" do
      #   expect(flash[:alert]).to eq("Please log in")
      # end
    end

    context "un-authenticated user" do
      before { get :show }

      it "redirects to login" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "flashes login notice" do
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

  end




  describe "#update_password" do
    before(:each) do
      sign_in user
    end

    context "authorized user" do
      # get :
    end

    context "unauthorized user" do

    end

    context "un-authenticated user" do

    end


  end




end
