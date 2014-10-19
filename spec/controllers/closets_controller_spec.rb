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
        sign_in user
        get :new
        expect(response).to render_template :new
      end
    end

    context "unauthenticated" do
      it "redirects to login" do
        sign_out user
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#create" do
    context "authorized" do
      before { sign_in user }

      it "saves closet" do
        expect{ post :create, closet: FactoryGirl.attributes_for(:closet) }.to change{user.closets.count}.by(1)
      end

      it "redirects to #index" do
        post :create, closet: FactoryGirl.attributes_for(:closet)
        expect(response).to redirect_to closets_path
      end

      it "does not save unpermitted attributes" do
        post :create, closet: FactoryGirl.attributes_for(:closet_3), id: 1001
        expect(user.closets.last.id).not_to eq(1001)
      end

      pending "can create from items#show" do
        # TODO - give the option of creating a closet from the product page, and then redirecting back to the product once created
        get root_path
        post :create, closet: FactoryGirl.attributes_for(:closet_3)
        expect(response).to redirect_to root_path
      end
    end

    context "unauthenticated" do
      it "redirects to login" do
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
    before(:each) { sign_in user }

    context "authorized user" do
      it "updates title" do
        put :update, id: user.closets.first.id,
            closet: FactoryGirl.attributes_for(:closet, title: "something else")
        user.closets.first.reload
        expect(user.closets.first.title).to eq("something else")
      end
    end

    context "un-authenticated user" do
      it "does not update title" do
        sign_out user
        put :update, id: user.closets.first.id,
            closet: FactoryGirl.attributes_for(:closet, title: "something else")
        user.closets.first.reload
        expect(user.closets.first.title).not_to eq("something else")
      end
    end
  end

  describe "#destroy" do
    context "authenticated" do
      before { sign_in user }

      describe "DELETE" do
        before { delete :destroy, id: user.closets.last.id }

        it "deletes user" do
          expect(user.closets.length).to eq(0)
        end

        it "redirects to #index" do
          expect(response).to redirect_to(closets_path)
        end
      end

      # TODO do we want GET requests to delete closets??
      describe "GET" do
        before { get :destroy, id: user.closets.last.id }

        it "deletes closet" do
          expect(user.closets.length).to eq(0)
        end

        it "redirects to #index" do
          expect(response).to redirect_to(closets_path)
        end
      end
    end

    context "unauthenticated" do
      before { sign_out user }

      describe "DELETE" do
        before { delete :destroy, id: user.closets.last.id }

        it "does not delete closet" do
          expect(user.closets.length).to eq(1)
        end

        it "redirects to login" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "GET" do
        before { delete :destroy, id: user.closets.last.id }

        it "does not delete closet" do
          expect(user.closets.length).to eq(1)
        end

        it "redirects to login" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context "unauthorized" do
      describe "DELETE" do
        before do
          sign_in user
          delete :destroy, id: user_2.closets.last.id
        end

        it "does not delete closet" do
          expect(user_2.closets.length).to eq(1)
        end

        it("redirects to #index") do
          expect(response).to redirect_to closets_path
        end
      end

      pending("should not be able to delete others' closet with GET") do
        fail()
      end
    end
  end


end
