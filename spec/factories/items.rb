# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  product_name       :text
#  description        :text
#  designer           :text
#  price_cents        :integer
#  currency           :string(255)
#  store_name         :string(255)
#  image_source       :text
#  image_source_array :text
#  product_link       :text
#  category1          :string(255)
#  category2          :string(255)
#  category3          :string(255)
#  state              :integer
#  created_at         :datetime
#  updated_at         :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
  end
end
