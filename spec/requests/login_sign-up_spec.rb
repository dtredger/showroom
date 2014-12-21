require "rails_helper"

RSpec.describe "Logins & Sign-ups", type: :request do

  feature "Visitor signs up" do
    scenario "with valid email and password" do
      sign_up_with "cool username", "cooluser@email.co", "cool_password"

      expect(page).to have_content("Logout")
    end

    scenario "with invalid email" do
      sign_up_with "cool username", "not cool email :(", "cool_password"

      expect(page).to have_content("Sign in")
    end

    scenario "with blank password" do
      sign_up_with "cool username", "cooluser@email.co", ""

      expect(page).to have_content("Sign in")
    end
  end

  feature "User signs in" do
    scenario "good credentials" do
      login

      expect(page).to have_content("Logout")
    end

    scenario "invalid credentials" do
      login "invalid"

      expect(page).to have_content("Sign in")
    end
  end

end
