require 'rails_helper'

RSpec.describe ClosetsController, :type => :controller do

  before(:each) do
    User.delete_all
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user_2) }

  describe "#index" do
    context "authorized" do

      it "shows user's default closets" do
        sign_in user
        get :index
        expect(user.closets.length).to eq(1)
      end

      pending "allows creating new closet" do
        User.delete_all
        sign_in user_2
        FactoryGirl.create(:closet_2)

        expect(user_2.closets.length).to eq(2)
      end
    end

    context "unauthenticated" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#show" do
    context "authorized" do
      it "renders #show" do
        sign_in user
        get :show, id: user.closets[0].id

        expect(response).to render_template :show
      end
    end

    context "unauthorized" do
      it "redirects to #index" do
        sign_in user
        sign_out user
        sign_in user_2
        get :show, id: user.closets[0].id

        expect(response).to redirect_to closets_path
      end
    end

    context "unauthenticated" do
      it "redirects to login" do
        sign_in user
        sign_out user
        get :show, id: user.closets[0].id

        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe "#new" do
    context "authorized" do
      it "renders #new" do
        get :new
        expect(response).to render_template :new
      end
    end

    context "unauthenticated" do
      it "redirects to login" do
        sign_in user
        sign_out user
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#create" do
    context "authorized" do
      it "saves closet" do
        sign_in user
        expect{ post :create, closet: FactoryGirl.attributes_for(:closet) }.to change{user.closets.count}.by(1)
      end

      it "redirects to #index" do
        sign_in user
        post :create, closet: FactoryGirl.attributes_for(:closet)
        expect(response).to redirect_to closets_path
      end

      it "does not save unpermitted attributes" do
        sign_in user
        post :create, closet: FactoryGirl.attributes_for(:closet_3), id: 1001
        expect(user.closets.last.id).not_to eq(1001)
      end

      it "creates closet from items#show page" do
        pending("give the option of creating a closet from the product page, and then redirecting back to the product once created")
      end
    end

    context "unauthenticated" do
      it "redirects to login" do
        sign_in user
        sign_out user
        post :create, closet: FactoryGirl.attributes_for(:closet)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "edit" do
    before(:each) { sign_in user }

    context "authorized" do
      it "renders #edit" do
        get :edit, id: user.closets.last.id
        expect(response).to render_template :edit
      end

      it "finds closet" do
        get :edit, id: user.closets.last.id
        expect(assigns[:closet].title).to eq("My Closet")
      end
    end

    context "unauthenticated" do
      it "redirects to login" do
        sign_out user
        get :edit, id: user.closets.last.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#update" do
    context "authorized user" do
      before { sign_in user }

      it "updates title" do
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

    context "unauthorized user" do
      pending('how is this tested?')
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
  end

  describe "#destroy" do

  end
end
