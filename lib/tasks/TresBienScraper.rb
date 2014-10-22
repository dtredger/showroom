	require_relative 'BasicScraper'

	class TresbienScraper < BasicScraper

		def find_number_of_pages(url)
			puts "Finding number of pages"
			open_url(url)
			links_array = Array.new

			pages = @site.css('.pages') # the result will be an array
			#puts "pages:" + pages.inspect

			if pages.empty?
				puts "Potentially one page..."
				puts "adding url: " + url
				links_array << url
			else
				puts "Potentially multiple pages..."
				links = pages.css('a')
				links.each do |link|
					if !links_array.include?(link['href'])
						puts "adding url: " + link['href']
						links_array << link['href']
					end
				end
			end
			puts "Links array: " + links_array.inspect
			return links_array
		end

		def category_scrape(url, category1)
			urls = find_number_of_pages(url)

			urls.each do |url|
				open_url(url)

				puts "Scraping category url: " + url

				items = @site.css('.products-grid') # each .products-grid should hold 3 items

				items.each do |i| # each i holds three items

					product = Hash.new
					item = String.new
					loop_items = Array.new

					if !i.css('.grid-1').nil?
						item1 = i.css('.grid-1')
						loop_items << item1
					elsif !i.css('.grid-2').nil?
						item2 = i.css('.grid-2')
						loop_items << item2
					elsif !i.css('.grid-3').nil?
						item3 = i.css('.grid-2')
						loop_items << item3
					end

					loop_items.each do |item|
						if !item.empty?
							item_link = item.at_css('a')['href']
							item_link = "http://tres-bien.com" + item_link
							item_name = item.at_css('.product-name').text.strip
							item_price = item.at_css('.regular-price').text.strip if item.at_css('.regular-price')
							item_image = item.at_css('img')['src']
							if item.at_css('.special-price')
								item_sale_price = item.at_css('.special-price').css('span')[1].text.strip # this dense line grabs the text of the second span tag under the .special-price div -- i.e., gets the price
							end

							puts "Item name: " + item_name
							puts "Item img link: " + item_image
							puts "Item link: " + item_link

							product.store("product_name", item_name)
							product.store("store_name", "Tres Bien Shop")
							product.store("image_source", item_image)
							product.store("product_link", item_link)
							product.store("currency", "USD")
							product.store("store_name", "Tres Bien Shop")
							product.store("category1", category1)

							if item_price
								item_price = item_price.gsub(/\D*/, '') # remove euro sign
								item_price_in_cents = item_price.to_i * 100
								puts "Item price: " + item_price
								puts "Item price in cents: " + item_price_in_cents.to_s
								product.store("price", item_price_in_cents)
							elsif item_sale_price
								item_sale_price = item_sale_price.gsub(/\D*/, '') # remove euro sign
								item_price_in_cents = item_sale_price.to_i * 100
								puts "Item (sale) price: " + item_sale_price
								puts "Item (sale) price in cents: " + item_price_in_cents.to_s
								product.store("price", item_price_in_cents)
							else # the item is sold out -- or something bizzare is going on
								next
							end

							@items_array << product
						end
					end
				end
			end
		end

		def scrape_items_detail
			## note must scrape designed from individual page

	      @items_array.each do |item|
	      	puts "item:" + item.inspect
	      	puts "item1 name: " + item["product_name"]
	      	puts "opening: " + item["product_link"].inspect

	        open_url(item["product_link"])


	        description = @site.at_css('#product-description').text
	        description = description.gsub('"', '')
	        description = description.strip
	        designer = @site.css('.product-info-container h2').text.strip

	        # remove designer name from product name
	        item["product_name"] = item["product_name"].gsub(designer, "")

	        images = @site.css('.shadowbox')
	        images = images.css('img')
	        image_array = Array.new
	        images.each do |image|
	          image_array << image['src']
	        end

	        puts "designer: " + designer
	        puts "description: " + description
	        puts "image_array" + image_array.inspect

	        item.store("designer", designer)
	        item.store("description", description)
	        item.store("image_source_array", image_array)

	        resize_image(item) # resize images
			end
		end

    def add_items_to_database
      @items_array.each do |item|

        puts "Adding item: " + item["product_name"]
        Item.create!(
          product_name: item["product_name"],
          description: item["description"],
          designer: item["designer"],
          price_cents: item["price"],
          currency: item["currency"],
          store_name: item["store_name"],
          image_source: item["image_source"],
          state: 0,
          image_source_array: item["image_source_array"],
          product_link: item["product_link"],
          category1: item["category1"])
      end
    end

	end
