# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  product_name :text
#  description  :text
#  designer     :text
#  price_cents  :integer
#  currency     :string(255)
#  store_name   :string(255)
#  product_link :text
#  category1    :string(255)
#  category2    :string(255)
#  category3    :string(255)
#  state        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  sku          :string(255)
#  slug         :string(255)      not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    sku "item_one sku"
    product_name "item_one product name"
    description "item_one description"
    designer "item_one designer"
    price_cents 100
    currency "USD"
    store_name "item_one store"
    product_link "http://item_one-link"
    category1 "item_one category"
    category2 nil
    category3 nil
    state "pending"

    factory :unique_item do
      sequence(:store_name) { |i| "unique store #{i}" }
      sequence(:product_name) { |i| "unique product #{i}" }
      sequence(:designer) { |i| "unique designer #{i}" }
    end
  end

  factory :item_2, class: Item do
    sku "item_two SKU"
    product_name "not Black Relaxed-Fit Wool Suit Trousers"
    description "different description"
    designer "not BURBERRY LONDON"
    price_cents 10101
    currency "CAD"
    store_name "item_2_store"
    product_link "http://www.mrporter.com/en-ca/mens/burberry_london/black-relaxed-fit-wool-suit-trousers/320022"
    category1 "Suits"
    category2 nil
    category3 nil
    state "live"

    factory :item_1_store do
      store_name "item_one store"
    end
  end

end
