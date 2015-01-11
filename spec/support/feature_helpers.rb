
module Features
  module SessionHelpers
    def sign_up_with(username, email, password)
      visit root_path
      # TODO - since this modal is already loaded, it is technically on-page;
      # loading via ajax would clarify, and reduce unnecessary loading of partial that might not be clicked
      within ".signup-form" do
        fill_in "user_username", with: username
        fill_in "user_email", with: email
        fill_in "user_password", with: password
        fill_in "user_password_confirmation", with: password
        click_button "Sign up"
      end
    end

    def login(invalid=nil)
      user = create(:user)
      (invalid == "invalid") ? username = "wrong" : username = user.username
      visit root_path
      # TODO - since this modal is already loaded, it is technically on-page;
      # loading via ajax would clarify, and reduce unnecessary loading of partial that might not be clicked
      within ".signin-form" do
        fill_in "user_login", with: username
        fill_in "user_password", with: user.password
        click_button "Sign in"
      end
    end

    def create_full_items(number)
      (1..number).each do |i|
        item = FactoryGirl.create(:unique_item,
          price: "#{i}00".to_i,
          designer: "designer #{i}",
          store_name: "store #{i}",
          product_name: "product_name #{i}",
          category1: "category #{i}",
          state: "live"
        )
        item.images.create(source: open(Rails.root.join("public/images/suit_sample_#{i}.jpg")))
      end
    end
  end
end


RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end
