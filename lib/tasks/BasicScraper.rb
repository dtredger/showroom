# require 'nokogiri'
# require 'open-uri'
# require 'time'
# require 'rmagick'
# require 'fileutils'
#
# class BasicScraper
#
#   # IMAGE_FILE_LOCATION = "#{Rails.root}/public/img"
#   # RESIZE_WIDTH = 280
#   # RESIZE_HEIGHT = 400
#   #
#   # def open_url(page_url)
#   #   Nokogiri::HTML(open(page_url))
#   # end
#   #
#   # def get_image(image_url)
#   #   # download image to memory
#   #   begin
#   #     image_string = open(image_url)
#   #     image_list = Magick::ImageList.new.from_blob(image_string.read)
#   #     image_list[0]
#   #   rescue Magick::ImageMagickError
#   #     "get_image ImageMagickError: bad image format - #{image_url}"
#   #   rescue Exception => e
#   #     "get_image error: #{e}"
#   #   end
#   # end
#   #
#   # # TODO - is it necessary for resize_image to write img to disk?
#   # def resize_image(magick_image)
#   #   # resize the image & save
#   #   begin
#   #     # the result may be smaller than 280x400 but no larger
#   #     new_proportion_image = magick_image.resize_to_fit(RESIZE_WIDTH, RESIZE_HEIGHT)
#   #
#   #     # create a blank image in case the above image is too small
#   #     # insert the above image into the blank image for padding
#   #     canvas = Magick::Image.new(RESIZE_WIDTH, RESIZE_HEIGHT) # create a blank 'canvas' image
#   #     # paste the item into our blank image
#   #     final_image = canvas.composite(new_proportion_image, Magick::CenterGravity, Magick::OverCompositeOp)
#   #
#   #     complete_file_path = "#{IMAGE_FILE_LOCATION}/#{rand(36**8).to_s(36)}.#{magick_image.format.downcase}"
#   #     final_image.write(complete_file_path)
#   #
#   #     # clear image from memory. var will be assigned to #<Magick::Image: (destroyed)>
#   #     [new_proportion_image, canvas, final_image].each { |img| img.destroy! }
#   #   rescue Exception => e
#   #     complete_file_path = "resize_image error: #{e}"
#   #   end
#   #   complete_file_path
#   # end
#   #
#   # def save_images(parent, image_urls)
#   #   image_urls.each do |img|
#   #     magick_img = get_image(img)
#   #     img_path = resize_image(magick_img)
#   #     parent.images.create(image: open(img_path))
#   #     File.delete(img_path) if File.exist?(img_path)
#   #   end
#   # end
#   #
#   # # TODO - resize_image writes img to disk, and then carrierwave does too (to /tmp)
#   # # TODO - not saving/resizing the images in the array currently
#   # def save_item_from_url(item_with_images)
#   #   begin
#   #     saved_item = Item.create!(item_with_images).except(:images)
#   #     save_images(saved_item, item_with_images[:images])
#   #   rescue ActiveRecord::RecordInvalid => e
#   #     "save_item_from_url RecordInvalid: #{e}"
#   #   rescue Exception => e
#   #     "save_item_from_url: #{e}"
#   #   end
#   #
#   # end
#   #
#   # def price_to_cents(price)
#   #   if price.is_a?(String)
#   #     stripped_string_price = price.gsub(",","").match(/\d{1,}\.*\d{,2}/).to_s
#   #     raise Exception, "price_to_cents error: price has no numbers" if stripped_string_price.blank?
#   #     cents_price = (stripped_string_price.to_f*100).to_i
#   #   elsif price.is_a? Float or price.is_a? Integer
#   #     cents_price = (price*100).to_i
#   #   else
#   #     raise Exception, "price_to_cents error: invalid price type"
#   #   end
#   #   cents_price
#   # end
#
# end
#
