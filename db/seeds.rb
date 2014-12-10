# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Creating default user: admin'
user1 = User.find_or_create_by_email :email => "admin@example.com", :username => "admin", :password => "admin"
user1.save(validate: false)


IMG_PATH = Rails.root.join("public/images/doge_log.gif")
IMG_2_PATH = Rails.root.join("public/images/lemongrab2.png")

(1..10).each do |i|
  item = Item.create!(
      product_link: "product_link #{i}",
      designer: "designer #{i}",
      store_name: "store #{i}",
      product_name: "product_name #{i}",
      description: "some description #{i}",
      sku: "1532s",
      price_cents: "100#{i}".to_i,
      category1: "category1 #{i}",
      state:1
  )
  item.images.create(image:open(IMG_PATH))
  item.images.create(image:open(IMG_2_PATH))
  puts "item #{i} and 2 images created"
end