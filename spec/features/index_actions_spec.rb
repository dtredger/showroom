require 'rails_helper'


RSpec.describe "IndexActions", type: :feature do

  feature "visits root page" do
    before { create_full_items 10 }

    scenario "non-user" do
      visit "/"

      expect(page).to have_content("")
    end

    scenario "user" do
      sign_up_with "cool username", "cooluser@email.co", "cool_password"
      visit "/"
    end

  end


end
