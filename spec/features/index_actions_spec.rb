# require 'rails_helper'
#
#
# RSpec.describe "IndexActions", type: :feature do
#
#   feature "non-user " do
#     before { create_full_items 10 }
#
#     scenario "visits root page" do
#       visit "/"
#
#       expect(page).to have_css("#item-0")
#       expect(page).to have_css("#item-9")
#     end
#
#     scenario "clicks add-to-closet button", js: true do
#       visit "/"
#       within "#item-4" do
#         find(".closet-button").click
#       end
#
#       within "#closet-modal" do
#         expect(page).to have_content("Shop all of Showspace")
#         expect(page).to have_content("Join Now")
#       end
#     end
#
#   end
#
#   feature "logged-in user" do
#     before do
#       create_full_items 10
#       sign_up_with "cool username", "cooluser@email.co", "cool_password"
#     end
#
#     scenario "visits root page" do
#       visit "/"
#
#       expect(page).to have_css("#item-0")
#       expect(page).to have_css("#item-9")
#     end
#
#     scenario "clicks add-to-closet button", js: true do
#       visit "/"
#       within "#item-4" do
#         find(".closet-button").click
#       end
#
#       within "#closet-modal" do
#         expect(page).to have_content("Choose closet to save to:")
#         expect(page).to have_content("Add item")
#       end
#     end
#   end
#
# end
