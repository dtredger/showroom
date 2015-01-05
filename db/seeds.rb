# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Creating default user user@showspace.com if doesn't exist: username: regular_user, password: regular_user"
User.create_with(username: "regular_user", password: "regular_user").find_or_create_by(email:"user@showspace.com")
puts "Creating admin user admin@showspace.com if doesn't exist: password: admin"
AdminUser.create_with(password: "admin").find_or_create_by(email:"admin@showspace.com")


IMG_PATH = Rails.root.join("public/images/doge_log.gif")
IMG_2_PATH = Rails.root.join("public/images/lemongrab2.png")
# SUIT_IMG_ROOT = Rails.root.join("public/images/suit_sample_#{i}.jpg")

(1..10).each do |i|
  calculated_state = i % 5 == 0 ? "retired" : "live"
  item = Item.create!(
      product_link: "product_link #{i}",
      designer: "designer #{i}",
      store_name: "store #{i}",
      product_name: "product_name #{i}",
      description: "Description ##{i}. Relatively long because etc. How long
        is the description on a real site? I don't know offhand, but it is probably a
        significantly long block of text, for selling high-end clothing.",
      sku: "1532s#{i}52-#{i}",
      price_cents: "#{i}0000".to_i,
      category1: "category #{i}",
      state: calculated_state # live
  )
  item.images.create(source: open(Rails.root.join("public/images/suit_sample_#{i}.jpg")))
  item.images.create(source: open(IMG_PATH))
  item.images.create(source: open(IMG_2_PATH))
  puts "item #{i} and #{item.images.count} images created"
end
