require 'rails_helper'



RSpec.describe "ClosetPages", type: :feature do

  feature "closets index" do
    before do
      sign_up_with "cool username", "cooluser@email.co", "cool_password"
      visit "/closets"
    end

    scenario("is on closets index") { expect(page.current_path).to eq(closets_path) }
    scenario("has default closet") { expect(page).to have_content("My Closet - 0 items") }
  end

  feature "create closets" do
    before do
      sign_up_with "cool username", "cooluser@email.co", "cool_password"
      visit "/closets"
      click_link "add-closet"
      fill_in "closet_title", with: "closet 2"
      fill_in "closet_summary", with: "second closet"
      click_button "Create Closet"
    end

    scenario "page notifies of closet creation" do
      expect(page).to have_content("Created a new closet")
    end

    scenario "index shows new closet" do
      expect(page).to have_content("closet 2 - 0 items")
    end
  end

end

