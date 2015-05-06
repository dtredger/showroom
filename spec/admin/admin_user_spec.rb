require 'rails_helper'

describe Admin::AdminUsersController, type: :controller do

  let(:user) { FactoryGirl.create (:user) }
  let(:admin_user) { FactoryGirl.create (:admin_user) }
  let(:admin_user_2) { FactoryGirl.create (:admin_user_2) }
  let(:admin_with_SMS) { FactoryGirl.create(:admin_with_SMS) }

  let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
  let(:resource)       { all_resources[AdminUser] }

  context "setup" do
    it "has correct name" do
      expect(resource.resource_name).to eq("AdminUser")
    end

    it "appears in menu" do
      expect(resource).to be_include_in_menu
    end
  end

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
        get :show, id: admin_user.id
        expect(response.status).to eq(200)
      end
    end
  end

  context "#create" do
    it "raises error" do
      sign_in admin_user
      expect{
        post :create,
             admin_user: FactoryGirl.attributes_for(:admin_user)
      }.to raise_exception
    end
  end

  context "#update" do
    it "raises error" do
      sign_in admin_user
      expect{
        put :update,
            id: admin_user.id,
            admin_user: FactoryGirl.attributes_for(:admin_user,
                email: "somethingelse@email.com",
                username: "something else",
                current_password: "admin_password")
      }.to raise_exception
    end
  end

  describe "notifiers" do
    before { sign_in admin_user }

    context "#test_error_notifier" do
      it "adds mail to queue" do
        expect{
          post :test_error_notifier
        }.to change { ActionMailer::Base.deliveries.count }.by 1
      end

      context "admin with SMS" do
        it "sends to SMS" do
          sign_in admin_with_SMS
          post :test_error_notifier
          expect(ActionMailer::Base.deliveries.last.to).to eq [admin_with_SMS.sms_gateway]
        end
      end

      context "admin with email only" do
        it "sends to email" do
          post :test_error_notifier
          expect(ActionMailer::Base.deliveries.last.to).to eq [admin_user.email]
        end
      end
    end

    context "#test_job_notifier" do
      it "adds mail to queue" do
        expect{
          post :test_job_notifier
        }.to change { ActionMailer::Base.deliveries.count }.by 1
      end
    end

  end

end


