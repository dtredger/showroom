# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null primary key
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
    product_name "Black Relaxed-Fit Wool Suit Trousers"
    description "You can't go wrong with a pair of Burberry London's..."
    designer "BURBERRY LONDON"
    price_cents 26000
    currency "USD"
    store_name "Mr. Porter"
    image_source "/img/items/Mr._Porter/BURBERRY_LONDON/073014/BURBERRY_L-Black_Relat4svr58f.jpeg"
    image_source_array ["http://cache.mrporter.com/images/products/320022/320022_mrp_in_l.jpg"]
    product_link "http://www.mrporter.com/en-ca/mens/burberry_london/black-relaxed-fit-wool-suit-trousers/320022"
    category1 "Suits"
    category2 nil
    category3 nil
    state 0
  end

end
