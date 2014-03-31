require 'nokogiri'
require 'open-uri'
require 'time'
require 'RMagick'
require 'pry'

class BasicScraper

	def initialize(url, category1)
      @items_array = Array.new
      category_scrape(url, category1)
      scrape_items_detail
      add_items_to_database
    end

    def open_url(url)
    	# Fake the browser
    	@site = Nokogiri::HTML(open(url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0.1"))
    end

    def resize_image(item_hash)

        # download bigger image to memory
        image_bigger = Magick::ImageList.new
        url_bigger = open(item_hash["image_source_array"][0])
        image_bigger.from_blob(url_bigger.read)
        image_bigger = image_bigger[0]

        # information to store local file + new url links
        store_path = "public/scraped_images/product_icons/" + item_hash["store_name"] + format_url_to_filename(item_hash["image_source_array"][0])
        local_url_path = "/scraped_images/product_icons/" + item_hash["store_name"] + format_url_to_filename(item_hash["image_source_array"][0])
        item_hash["image_source"] = local_url_path

        # resize the image to a maximum dimension of 280x400
        # the result may be smaller than 280x400 but no larger
        image_bigger = image_bigger.resize_to_fit(280, 400)

        # create a blank image incase the above image is too small
        # insert the above image into the blank image for padding
        final_image = Magick::Image.new(280, 400) # create a blank 'canvas' image
        final_image = final_image.composite(image_bigger, Magick::CenterGravity, Magick::OverCompositeOp) # paste the item into our blank image

        final_image.write(store_path)
        image_bigger.destroy! # clear image from memory
        final_image.destroy! # clear image from memory
    end

    def format_url_to_filename(url)
    	new_url = url.gsub("/", "-").gsub(":", "-").gsub("#", "-").gsub("%20", "-")
      return new_url
    end

end

