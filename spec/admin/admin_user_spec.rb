require 'rails_helper'

describe Admin::AdminUsersController, type: :controller do

  let(:admin_user) { AdminUser }
  let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
  let(:resource)       { all_resources[admin_user] }

  describe "setup" do
    it "has correct name" do
      expect(resource.resource_name).to eq("AdminUser")
    end

    it "appears in menu" do
      expect(resource).to be_include_in_menu
    end

  end


end


