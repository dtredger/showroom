require 'rails_helper'

RSpec.describe "Searches", :type => :feature do
  feature "nav-search" do
    scenario "price range" do
      create_full_items 10
      visit root_path
      fill_in "min_price", with: "500"
      fill_in "max_price", with: "700"
      click_button "Search"

      expect(page).to have_content("$500")
      expect(page).to have_content("$700")

      expect(page).not_to have_content("$300")
      expect(page).not_to have_content("$800")
    end
  end


end
