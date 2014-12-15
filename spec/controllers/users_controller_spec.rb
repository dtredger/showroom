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

RSpec.describe UsersController, type: :controller do
  # tell Devise which mapping should be used before a request. This is necessary because Devise
  # gets this information from the router, but since functional tests do not pass through the router,
  # it needs to be told explicitly. For example, if you are testing the user scope, simply do:

  # before(:each) do
  #   @request.env["devise.mapping"] = Devise.mappings[:user]
  # end

  let(:user) { create(:user) }
  let(:user2) { create(:user_2) }

  # /profile page
  describe "#show" do
    context "un-authenticated user" do
      before { get :show }

      it { expect(response).to redirect_to(new_user_session_path) }
      it "flashes login notice" do
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

    context "authorized user" do
      before do
        sign_in user
        get :show
      end

      it { expect(response).to render_template(:show) }
      it("sets correct user") { expect(subject.current_user.id).to eq(user.id) }
    end
  end


  describe "#edit_password" do
    context "un-authenticated user" do
      before { get :edit_password }

      it { expect(response).to redirect_to(new_user_session_path) }
      it "flashes login notice" do
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

    context "authenticated user" do
      it "assigns correct user" do
        sign_in user2
        get :edit_password
        expect(assigns[:user]).to eq(user2)
      end
    end
  end

  describe "#update_password" do
    context "un-authenticated user" do
      before do
        post :update_password, user: user2.id,
             current_password: user2.password,
             password: "something else",
             password_confirmation: "something else"
        user2.reload
      end

      it { expect(response).to redirect_to(new_user_session_path) }

      it "flashes login notice" do
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end

      it "does not update password" do
        expect(user2.password).not_to eq("something new")
      end
    end

    context "authenticated user" do
      before do
        sign_in user2
      end

      # TODO - WTF why won't this work? is exactly the same as other update specs
      # appears user is being interpreted as string: something related to relying
      # on current_user in the controller? if uses find(params[:id]), can't find
      # user2. But action seems to work not under test
      it "updates password" do
        patch :update_password, user: user2.id,
             current_password: user2.password,
             password: "something new",
             password_confirmation: "something new"
        user2.reload
        expect(user2.password).to eq("something new")
      end
    end
  end

end
