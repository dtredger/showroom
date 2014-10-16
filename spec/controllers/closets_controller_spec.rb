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

  end

  describe "edit" do

  end

  describe "#update" do

  end

  describe "#destroy" do

  end
end
