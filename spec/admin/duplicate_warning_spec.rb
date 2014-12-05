require 'rails_helper'

describe Admin::DuplicateWarningsController, type: :controller do

  let!(:item_1) { FactoryGirl.create (:item) }
  let!(:item_2) { FactoryGirl.create (:item_2) }
  let!(:item_3) { FactoryGirl.create (:item) }
  let!(:item_4) { FactoryGirl.create (:item_2) }

  let(:user) { FactoryGirl.create (:user) }
  let(:admin_user) { FactoryGirl.create (:admin_user) }

  let(:duplicate_warning) { DuplicateWarning }
  let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
  let(:resource)       { all_resources[duplicate_warning] }


  describe "Admin/Duplicate_warning" do
    it "has correct name" do
      expect(resource.resource_name).to eq("DuplicateWarning")
    end

    it "appears in menu" do
      expect(resource).to be_include_in_menu
    end
  end

  context "batch actions" do
    before do
      DuplicateWarning.delete_all
      @duplicate_warning = DuplicateWarning.create(
          existing_item_id: item_1.id,
          pending_item_id: item_2.id)
      @duplicate_warning_2 = DuplicateWarning.create(
          existing_item_id: item_3.id,
          pending_item_id: item_4.id)
    end

    context "unauthenticated" do
      it "redirects to admin login" do
        post :batch_action, batch_action: 'destroy',
             collection_selection: [@duplicate_warning.id]
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "unauthorized" do
      it "redirects to admin login" do
        sign_in user
        post :batch_action, batch_action: 'destroy',
             collection_selection: [@duplicate_warning.id]
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "authorized" do
      describe "delete selected" do
        before do
          sign_in admin_user
          post :batch_action, batch_action: 'destroy',
               collection_selection: [@duplicate_warning.id, @duplicate_warning_2.id]
        end

        it "destroys all selected warnings" do
          expect(DuplicateWarning.all).to be_empty
        end

        it "does not delete associated items" do
          expect(item_1).not_to be_nil
        end
      end

      describe "delete_all_pending_items" do
        before do
          sign_in admin_user
          post :batch_action, batch_action: 'delete_all_pending_items',
               collection_selection: [@duplicate_warning.id, @duplicate_warning_2.id]
        end

        it "deletes pending items" do
          expect(Item.find_by_id(item_2.id)).to be_nil
          expect(Item.find_by_id(item_4.id)).to be_nil
        end

        it "does not delete existing items" do
          expect(Item.find_by_id(item_1.id)).not_to be_nil
          expect(Item.find_by_id(item_3.id)).not_to be_nil
        end

        it "deletes warnings" do
          expect(DuplicateWarning.all).to be_empty
        end
      end

      describe "delete_all_existing_items" do
        before do
          sign_in admin_user
          post :batch_action, batch_action: 'delete_all_existing_items',
               collection_selection: [@duplicate_warning.id, @duplicate_warning_2.id]
        end

        it "deletes existing items" do
          expect(Item.find_by_id(item_1.id)).to be_nil
          expect(Item.find_by_id(item_3.id)).to be_nil
        end

        it "does not delete pending items" do
          expect(Item.find_by_id(item_2.id)).not_to be_nil
          expect(Item.find_by_id(item_4.id)).not_to be_nil
        end

        it "deletes warnings" do
          expect(DuplicateWarning.all).to be_empty
        end
      end
    end

  end


end


