require 'rails_helper'

describe Admin::AdminUsersController, type: :controller do

  let(:admin_user) { FactoryGirl.create (:admin_user) }
  let(:admin_user_2) { FactoryGirl.create (:admin_user_2) }

  let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
  let(:resource)       { all_resources[AdminUser] }

  describe "setup" do
    it "has correct name" do
      expect(resource.resource_name).to eq("AdminUser")
    end

    it "appears in menu" do
      expect(resource).to be_include_in_menu
    end
  end

  describe "actions" do
    it "rejects creates" do
      sign_in admin_user
      expect{
        post :create,
        admin_user: FactoryGirl.attributes_for(:admin_user)
      }.to raise_exception
    end

    # TODO - possible we want to allow admins to edit themselves in the future
    it "rejects updates" do
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


end


