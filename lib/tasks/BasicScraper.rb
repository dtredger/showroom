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

        # grab format of image
        image_format_extension = '.' + image.bigger.format.downcase

        # information to store local file + new url links
        local_url_path = format_item_to_local_url_path(item, image_format_extension)
        store_path = 'public/' + local_url_path
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

    def format_item_to_local_url_path(item_hash, image_format_extension)
        # http://stackoverflow.com/questions/885414/a-concise-explanation-of-nil-v-empty-v-blank-in-ruby-on-rails
        store_name = item_hash['store_name'].blank? ? 'NA' : item_hash['store_name']
        designer = item_hash['designer'].blank? ? 'NA' : item_hash['designer']
        product_name = item_hash['product_name'].blank? ? 'NA' : item_hash['product_name']
        date = Time.now.strftime("%m%d%y")

        # sanitize strings
        store_name = store_name.gsub(' ', '_').gsub('%20', '_').gsub(/[^\.0-9a-z_-]/i, '_')
        designer = designer.gsub(' ', '_').gsub('%20', '_').gsub(/[^\.0-9a-z_-]/i, '_')
        product_name = product_name.gsub(' ', '_').gsub('%20', '_').gsub(/[^\.0-9a-z_-]/i, '_')

        # limit length of strings
        designer_shortened = designer.truncate(10, omission: '')
        product_name_shortened = product_name.truncate(10, omission: '')

        # generate 8 char token to avoid collision
        # http://zh.soup.io/post/36288765/How-to-create-small-unique-tokens-in
        token = rand(36**8).to_s(36)

        local_url_path = '/img/items/' + store_name + '/' + designer + '/' + date + '/' + designer_shortened + '-' + product_name_shortened + token + image_format_extension
    end

end

