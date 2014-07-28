require_relative 'BasicScraper'

class MrPorterScraper < BasicScraper

	def find_number_of_pages(url)

		puts "Finding number of pages"
		open_url(url)
		links_array = Array.new

		pages = @site.css('.product-list-menu-page-filter')

		# parse text for integer # of pages
		@number_of_pages = pages.at_css('.page-on').text.strip
		@number_of_pages = @number_of_pages[-1] # get last digit -- presuming pages rarely exceed 3

		puts "# of pages: " + @number_of_pages

		# grab the next page link stored in 3rd li element
		page_link = pages.css('li')[2] # grab 3rd li element
		page_link = page_link.at_css('a')['href']

		puts "Page link: " + page_link

		@base_url = "http://www.mrporter.com/" + page_link[0...-1] # chop off last number from url
		puts "Base url: " + @base_url
	end

	def category_scrape(url, category)
		# ! grab alt image as well

		puts "Scraping category..."

		find_number_of_pages(url)

		i = 0
		while i <= @number_of_pages.to_i
			i += 1

			open_url(@base_url + i.to_s)
			puts "Opening url: " + @base_url + i.to_s


			image_rows = @site.css('.product-images')
			detail_rows = @site.css('.product-details')

			if image_rows.length != detail_rows.length
				puts "Fatal: image rows doesn't match detail rows"
				exit
			end

			for j in 0..(image_rows.length - 1)
				product1 = Hash.new
				product2 = Hash.new
				product3 = Hash.new

				# image rows
				
				images = image_rows[j].css('.product-image')

				if images[0]
					image1_product_link = images[0].at_css('a')['href']
					image1_product_link = "http://www.mrporter.com" + image1_product_link
					image1_img_link = images[0].at_css('img')['src']
					image1_img_link = "http:" + image1_img_link

					product1.store("product_link", image1_product_link)
					product1.store("image_source", image1_img_link )
					product1.store("category1", category)

					puts "#1 product link: " + image1_product_link
					puts "#1 image link: " + image1_img_link
				end

				if images[1]
					image2_product_link = images[1].at_css('a')['href']
					image2_product_link = "http://www.mrporter.com" + image2_product_link
					image2_img_link = images[1].at_css('img')['src']
					image2_img_link = "http:" + image2_img_link

					product2.store("product_link", image2_product_link)
					product2.store("image_source", image2_img_link )
					product2.store("category1", category)

					puts "#2 product link: " + image2_product_link
					puts "#2 image link: " + image2_img_link
				end


				if images[2]
					image3_product_link = images[2].at_css('a')['href']
					image3_product_link = "http://www.mrporter.com" + image3_product_link
					image3_img_link = images[2].at_css('img')['src']
					image3_img_link = "http:" + image3_img_link

					product3.store("product_link", image3_product_link)
					product3.store("image_source", image3_img_link )
					product3.store("category1", category)

					puts "#3 product link: " + image3_product_link
					puts "#3 image link: " + image3_img_link
					@items_array << product3
				end

				# grab info from description rows in syn w/ image rows

				details = detail_rows[j].css('.description')

				if details[0]
					product1_designer = details[0].at_css('.product-designer').text.strip
					product1_designer = product1_designer.upcase
					product1_name = details[0].at_css('.product-title').text.strip
					product1_price = details[0].at_css('.price-container').text.strip
					product1_price = product1_price.gsub("$", '') # strip dollar sign
					product1_price = product1_price.gsub(",", '') # strip commas

					product1.store("designer", product1_designer)
					product1.store("product_name", product1_name )
					product1.store("price", product1_price )

					puts "#1 designer: " + product1_designer
					puts "#1 name: " + product1_name
					puts "#1 price: " + product1_price
					
					if !@items_array.any? { |h| h["product_link"] == product1["product_link"]} # check if the link is already in our array somehow...
						@items_array << product1
					end
				end

				if details[1]
					product2_designer = details[1].at_css('.product-designer').text.strip
					product2_designer = product2_designer.upcase
					product2_name = details[1].at_css('.product-title').text.strip
					product2_price = details[1].at_css('.price-container').text.strip
					product2_price = product2_price.gsub("$", '') # strip dollar sign
					product2_price = product2_price.gsub(",", '') # strip commas

					product2.store("designer", product2_designer)
					product2.store("product_name", product2_name )
					product2.store("price", product2_price )

					puts "#2 designer: " + product2_designer
					puts "#2 name: " + product2_name
					puts "#2 price: " + product2_price
					
					if !@items_array.any? { |h| h["product_link"] == product2["product_link"]} # check if the link is already in our array somehow...
						@items_array << product2
					end
				end

				if details[2]
					product3_designer = details[2].at_css('.product-designer').text.strip
					product3_designer = product3_designer.upcase
					product3_name = details[2].at_css('.product-title').text.strip
					product3_price = details[2].at_css('.price-container').text.strip
					product3_price = product3_price.gsub("$", '') # strip commas
					product3_price = product3_price.gsub(",", '') # strip commas

					product3.store("designer", product3_designer)
					product3.store("product_name", product3_name )
					product3.store("price", product3_price )

					puts "#3 designer: " + product3_designer
					puts "#3 name: " + product3_name
					puts "#3 price: " + product3_price

					if !@items_array.any? { |h| h["product_link"] == product3["product_link"]} # check if the link is already in our array somehow...
						@items_array << product3
					end
				end
			end
		end
		puts "Finished category scrape..."
	end

	def scrape_items_detail
		puts "Scraping item details..."
		#puts @items_array.inspect

		@items_array.each do |item|

			#puts item.inspect

			#puts item.inspect

			open_url(item["product_link"])
			image_array = Array.new

			image1 = @site.css('#medium-image-container')
			image1 = image1.at_css('img')['src']
			image1 = "http:" + image1
			#puts image1

			image_array << image1
			item.store("image_source_array", image_array)

			meta_desc = @site.at("meta[property='og:description']")
			description = meta_desc['content']
			description = description.strip
			puts "Description: #{description}"


			item.store("description", description)
			item.store("currency", "USD")
			item.store("store_name", "Mr. Porter")
			item.store("state", 0)

			resize_image(item) # resize images

			# if @site.at_css('.colour')
			# 	color = @site.at_css('.colour').text.strip
			# end

			# if @site.at_css('#select-size')
			# 	sizes = @site.css('#select-size')
			# 	sizes = sizes.at_css('option').text.strip
			# end
		end

	end

	def add_items_to_database
		puts "Adding items to database..."
		@items_array.each do |item|
			Item.create!(item)
		end
		# output_file = CSV.open("MrPorter2.csv", "wb")
		# output_file << ["product_name", "product_link", "designer", "price",  "image_source", "image_source_array", "description"]

		# @items_array.each do |item|
		# 	output_file << [item["product_name"], item["product_link"], item["designer"], item["price"], item["image_source"], item["image_source_array"][0], item["description"]]
		# end
	end

	#puts @items_array.inspect
end

