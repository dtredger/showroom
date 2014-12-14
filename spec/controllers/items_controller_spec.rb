require 'rails_helper'

RSpec.describe ItemsController, :type => :controller do

  let!(:item1) { FactoryGirl.create(:unique_item, state: 1, designer: "lemon", price_cents: 2) }
  let!(:item2) { FactoryGirl.create(:unique_item, state: 1, category1: "test", price_cents: 200) }
  let!(:item3) { FactoryGirl.create(:unique_item, state: 1, category1: "test", price_cents: 300) }
  let!(:item4) { FactoryGirl.create(:unique_item) }

  describe "#index" do
    context "default" do
      before { get :index }

      it { expect(response.status).to eq(200) }
      it("includes live @items") { expect(assigns[:items].length).to eq(3) }
      it("includes correct items") { expect(assigns[:items]).to include(item1, item2, item3) }
      it("does not contain pending items") { expect(assigns[:items]).not_to include(item4)}
      it("builds closet item") { expect(assigns[:closets_item]).not_to be_nil }
    end

    context "#handle_search" do
      describe "designer only" do
        it "returns single match" do
          get :index, designer: "lemon"
          expect(assigns[:items].length).to eq(1)
          expect(assigns[:items]).to include(item1)
        end
      end

      describe "category and price range" do
        before { get :index, category1: "test", min_price: "2", max_price: "3" }
        it("returns two matches") { expect(assigns[:items].length).to eq(2) }
        it("includes correct items") { expect(assigns[:items]).to include(item2, item3) }
        it "#value_to_cents converts price param to cents" do
          expect(assigns[:items]).not_to include(item1)
        end
      end
    end
  end

  describe "#show" do
    context "non-live item" do
      before { get :show, id: item4.id }
      it("redirects to index") { expect(response).to redirect_to(root_path) }
    end

    context "live item" do
      before { get :show, id: item2.id }

      it { expect(response.status).to eq(200) }
      it("assigns correct item") { expect(assigns[:item]).to eq(item2) }
      it("builds closet item") { expect(assigns[:closets_item]).not_to be_nil }
      it("builds like") { expect(assigns[:like]).not_to be_nil }
    end
  end

end
