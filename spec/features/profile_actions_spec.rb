require 'rails_helper'

RSpec.describe "Profile Actions", type: :feature do

  feature "account details" do
    before do
      sign_up_with "cool username", "cooluser@email.co", "cool_password"
      visit "/profile"
    end

    scenario("is at /profile") { expect(page).to have_content("My profile") }
    scenario("has email") { expect(page).to have_content("cooluser@email.co") }
    scenario("has username") { expect(page).to have_content("cool username") }
  end

  feature "edit account" do
    before do
      sign_up_with "cool username", "cooluser@email.co", "cool_password"
      visit "/profile"
      within ".account-info" do
        click_link "enable-update"
      end
    end

    scenario "update username" do
      fill_in "user_username", with: "cats"
      fill_in "user_current_password", with: "cool_password"

      expect(page).not_to have_content("cool username")
      expect(page).to have_content("cats")
    end

    scenario "update email" do
      click_link "enable-update"
      fill_in "user_email", with: "new@email.co"
      fill_in "user_current_password", with: "cool_password"

      expect(page).not_to have_content("cooluser@eemail.co")
      expect(page).to have_content("new@email.co")
    end

    scenario "update password" do
      click_link "enable-update"
      fill_in "user_email", with: "new@email.co"
      fill_in "user_current_password", with: "cool_password"

      expect(page).not_to have_content("cooluser@email.co")
      expect(page).to have_content("new@email.co")
    end

  end

  feature "delete account" do
    scenario "confirmed" do
      click_button "Delete my account"
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_content("cooluser@email.co")
      expect(page).to have_content("see you again")
      expect(page.current_path).to eq(root_path)
    end
  end


end
