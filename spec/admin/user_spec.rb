require 'rails_helper'

describe Admin::UsersController, type: :controller do

  let(:item_1) { FactoryGirl.create (:unique_item) }

  let(:duplicate_warning) { FactoryGirl.create(:duplicate_warning, existing_item_id: item_1.id, pending_item_id: item_2.id) }

  let!(:admin_user) { FactoryGirl.create (:admin_user) }
  let!(:user) { FactoryGirl.create (:user) }


  describe "#index" do
    context "unauthorized" do
      it "redirects to login" do
        sign_in user
        get :index
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "authorized" do
      it "gives 200" do
        sign_in admin_user
        get :index
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#show" do
    context "unauthorized" do
      it "redirects to login" do
        sign_in user
        get :show, id: admin_user.id
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "authorized" do
      it "gives 200" do
        sign_in admin_user
        get :show, id: user.id
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#new" do
    context "unauthorized" do
      it "redirects to login" do
        sign_in user
        get :new
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "authorized" do
      it "gives 200" do
        sign_in admin_user
        get :new
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#create" do
    context "unauthorized" do
      it "redirects to login" do
        sign_in user
        post :create, user: attributes_for(:unique_user)
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "authorized" do
      before do
        sign_in admin_user
      end

      it 'redirects to new user' do
        post :create, user: FactoryGirl.attributes_for(:unique_user)
        expect(response.status).to be(302)
      end

      it "creates user" do
        expect{
          post :create, user: FactoryGirl.attributes_for(:unique_user)
        }.to change{User.count}.by(1)
      end
    end
  end

  context "#update" do
    it "raises error" do
      sign_in admin_user
      expect{
        put :update,
             user: FactoryGirl.attributes_for(:user, username: 'something_new@email.co')
      }.to raise_exception
    end
  end



end