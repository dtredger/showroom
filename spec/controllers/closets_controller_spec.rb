require 'rails_helper'

RSpec.describe ClosetsController, :type => :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user_2) }

  let(:closet_2) { FactoryGirl.create(:unique_closet, user_id: user.id) }
  let(:closet_3) { FactoryGirl.create(:unique_closet, user_id: user.id) }
  let(:closet_4) { FactoryGirl.create(:unique_closet, user_id: user_2.id) }

  describe "#index" do
    context "authorized" do
      before do
        sign_in user
        get :index
      end

      it { expect(response).to render_template(:index) }
      it("has one closet") { expect(user.closets.length).to eq(1) }
      it "has default closet name" do
        expect(user.closets).to include(Closet.where(title:"My Closet").first)
      end
    end

    context "unauthorized" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#show" do
    context "unauthenticated" do
      it "redirects to login" do
        get :show, id: closet_3.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "unauthorized" do
      it "redirects to closets#index" do
        sign_in user_2
        get :show, id: closet_3.id
        expect(response).to redirect_to closets_path
      end
    end

    context "authorized" do
      before do
        sign_in user
        get :show, id: closet_3.id
      end

      it { expect(response).to render_template(:show) }
      it("assigns correct closet") { expect(assigns[:closet]).to eq(closet_3) }
    end
  end

  describe "#new" do
    context "unauthenticated" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "authenticated" do
      before do
        sign_in user
        get :new
      end

      it("renders #new") { expect(response).to render_template(:new) }
      it { expect(assigns[:closet]).to be_a(Closet) }
    end
  end

  describe "#create" do
    context "unauthorized" do
      it "redirects to login" do
        post :create, closet: FactoryGirl.attributes_for(:closet)
        expect(response).to redirect_to new_user_session_path
      end

      it "does not create closet" do
        expect{
          post :create, closet: FactoryGirl.attributes_for(:closet)
        }.not_to change{Closet.count}
      end
    end

    context "authorized" do
      before { sign_in user }

      it "saves closet" do
        expect{
          post :create, closet: FactoryGirl.attributes_for(:closet)
        }.to change{user.closets.count}.by(1)
      end

      it "redirects to #index" do
        post :create, closet: FactoryGirl.attributes_for(:closet)
        expect(response).to redirect_to closets_path
      end

      it "does not save unpermitted attributes" do
        post :create, closet: FactoryGirl.attributes_for(:closet_3, id: 1001)
        expect(user.closets.last.id).not_to eq(1001)
      end

      it "cannot create closet for another" do
        # TODO - currently still builds a closet for signed-in: should it reject entirely?
        post :create, closet: FactoryGirl.attributes_for(:unique_closet, user_id: user_2.id)
        expect{
          post :create, closet: FactoryGirl.attributes_for(:unique_closet, user_id: user_2.id)
        }.not_to change{user_2.closets.count}
      end

      pending "can create from items#show" do
        # TODO - give the option of creating a closet from the product page, and then redirecting back to the product once created
        get root_path
        post :create, closet: FactoryGirl.attributes_for(:closet_3)
        expect(response).to redirect_to root_path
      end
    end

  end

  describe "edit" do
    context "unauthorized" do
      it "redirects to login" do
        get :edit, id: closet_2.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "authorized" do
      before { sign_in user }
      let!(:closet_title) { FactoryGirl.create(:unique_closet, user_id: user.id, title: "unique title") }

      it do
        get :edit, id: closet_title.id
        expect(response).to render_template :edit
      end

      it("finds closet") do
        get :edit, id: closet_title.id
        expect(assigns[:closet].title).to eq("unique title")
      end
    end
  end

  describe "#update" do
    context "unauthenticated user" do
      it "does not update title" do
        put :update, id: closet_2.id,
            closet: FactoryGirl.attributes_for(:closet, title: "something else")
        closet_2.reload
        expect(closet_2.title).not_to eq("something else")
      end
    end

    context "authorized user" do
      it "updates title" do
        sign_in user
        put :update, id: closet_2.id,
            closet: FactoryGirl.attributes_for(:closet, title: "something else")
        closet_2.reload
        expect(closet_2.title).to eq("something else")
      end
    end
  end

  describe "#destroy" do
    context "unauthenticated" do
      describe "DELETE" do
        before { delete :destroy, id: closet_2.id }

        it "does not delete closet" do
          expect(Closet.find(closet_2.id)).not_to be_nil
        end

        it "redirects to login" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "GET" do
        before { get :destroy, id: closet_2.id }

        it "does not delete closet" do
          expect(Closet.find(closet_2.id)).not_to be_nil
        end

        it "redirects to login" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context "unauthorized" do
      before { sign_in user_2 }

      describe "DELETE" do
        before { delete :destroy, id: closet_2.id }

        it "does not delete closet" do
          expect(Closet.find(closet_2.id)).not_to be_nil
        end

        it "redirects to closets#index" do
          expect(response).to redirect_to(closets_path)
        end
      end

      describe "GET" do
        before { get :destroy, id: closet_2.id }

        it "does not delete closet" do
          expect(Closet.find(closet_2.id)).not_to be_nil
        end

        it "redirects to closets#index" do
          expect(response).to redirect_to(closets_path)
        end
      end
    end

    context "authenticated" do
      before { sign_in user }

      describe "DELETE" do
        before { delete :destroy, id: closet_2.id }

        it "deletes closet" do
          expect(Closet.find_by_id(closet_2.id)).to be_nil
        end

        it "redirects to closets#index" do
          expect(response).to redirect_to(closets_path)
        end
      end

      # TODO do we want GET requests to delete closets??
      describe "GET" do
        before { get :destroy, id: closet_2.id }

        it "does not delete closet" do
          expect(Closet.find(closet_4.id)).not_to be_nil
        end

        it "redirects to closets#index" do
          expect(response).to redirect_to(closets_path)
        end
      end
    end

  end


end
