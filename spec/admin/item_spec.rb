require 'rails_helper'

describe Admin::ItemsController, type: :controller do

  before do
    Item.delete_all
    DuplicateWarning.delete_all
  end

  let!(:item_1) { FactoryGirl.create (:item) }
  let!(:item_2) { FactoryGirl.create (:item_2) }
  let!(:item_3) { FactoryGirl.create (:item) }
  let!(:item_4) { FactoryGirl.create (:item_2) }

  let(:user) { FactoryGirl.create (:user) }
  let(:admin_user) { FactoryGirl.create (:admin_user) }

  let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
  let(:resource)       { all_resources[item] }


  context "batch actions" do
    context "unauthenticated" do
      it "redirects to admin login" do
        post :batch_action, batch_action: 'set_live',
             collection_selection: [item_1.id]
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "unauthorized" do
      it "redirects to admin login" do
        sign_in user
        post :batch_action, batch_action: 'set_live',
             collection_selection: [item_1.id]
        expect(response).to redirect_to new_admin_user_session_path
      end
    end

    context "authorized" do
      describe "set live" do
        before do
          @duplicate_warning = DuplicateWarning.create(
              existing_item_id: item_1.id,
              pending_item_id: item_2.id)
          sign_in admin_user
          post :batch_action, batch_action: 'set_live',
               collection_selection: [item_1.id, item_2.id, item_3.id, item_4.id]
        end

        it "sets items live" do
          expect(Item.find(item_1).state).to eq(1)
          expect(Item.find(item_2).state).to eq(1)
          expect(Item.find(item_3).state).to eq(1)
          expect(Item.find(item_4).state).to eq(1)
        end

        it "does not alter duplicate warnings" do
          expect(@duplicate_warning).not_to be_nil
        end

        it "flashes notice" do
          expect(flash[:notice]).not_to be_empty
        end
      end

      describe "retire" do
        before do
          @duplicate_warning = DuplicateWarning.create(
              existing_item_id: item_1.id,
              pending_item_id: item_2.id)
          sign_in admin_user
          post :batch_action, batch_action: 'retire',
               collection_selection: [item_1.id, item_2.id, item_3.id, item_4.id]
        end

        it "retires" do
          expect(Item.find(item_1).state).to eq(2)
          expect(Item.find(item_2).state).to eq(2)
          expect(Item.find(item_3).state).to eq(2)
          expect(Item.find(item_4).state).to eq(2)
        end

        it "does not alter duplicate warnings" do
          expect(@duplicate_warning).not_to be_nil
        end

        it "flashes notice" do
          expect(flash[:notice]).not_to be_empty
        end
      end

    end


  end

end