# == Schema Information
#
# Table name: closets_items
#
#  closet_id :integer
#  item_id   :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :closets_item do
    association :closet, factory: :closet
    association :item, factory: :item
  end
end
