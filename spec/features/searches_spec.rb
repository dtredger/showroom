require 'rails_helper'

RSpec.describe "Searches", type: :feature do
  feature "nav-search" do
    before do
      create_full_items 10
      visit root_path
    end

    scenario "price range" do
      fill_in "min_price", with: "500"
      fill_in "max_price", with: "700"
      click_button "Search"

      within(:css, ".medium-12") do
        expect(page).to have_content("$500")
        expect(page).to have_content("$700")
        expect(page).not_to have_content("$300")
        expect(page).not_to have_content("$800")
      end
    end

    scenario "designer" do
      select "designer 3", from: "designer"
      click_button "Search"

      within(:css, ".medium-12") do
        expect(page).to have_content("designer 3")
        expect(page).not_to have_content("designer 4")
        expect(page).not_to have_content("designer 2")
      end
    end

    scenario "category" do
      select "category 5", from: "category"
      click_button "Search"

      within(:css, ".medium-12") do
        expect(page).to have_content("category 5")
        expect(page).not_to have_content("category 4")
        expect(page).not_to have_content("category 6")
      end
    end
  end
end
