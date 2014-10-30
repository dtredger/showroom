require 'nokogiri'
require 'open-uri'
require 'time'
require 'RMagick'
require 'pry'
require 'fileutils'

class BasicScraper

  FAKE_UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0.1"
  IMAGE_FILE_LOCATION = "#{Rails.root}/public/img"
  RESIZE_WIDTH = 280
  RESIZE_HEIGHT = 400

  def open_url(page_url)
    begin
      dom = Nokogiri::HTML(open(page_url, "User-Agent" => FAKE_UA))
    rescue Exception => e
      dom = "Open_url Error: #{e}"
    end
    dom
  end

  def get_image(image_url)
    # download image to memory
    begin
      image_string = open(image_url)
      image_list = Magick::ImageList.new.from_blob(image_string.read)
      magick_image = image_list[0]
    rescue Magick::ImageMagickError
      magick_image = "get_image ImageMagickError: bad image format - #{image_url}"
    rescue Exception => e
      magick_image = "get_image error: #{e}"
    end
    magick_image
  end

  # TODO - is it necessary for resize_image to write img to disk?
  def resize_image(magick_image)
    # resize the image & save
    begin
      # the result may be smaller than 280x400 but no larger
      new_proportion_image = magick_image.resize_to_fit(RESIZE_WIDTH, RESIZE_HEIGHT)

      # create a blank image in case the above image is too small
      # insert the above image into the blank image for padding
      canvas = Magick::Image.new(RESIZE_WIDTH, RESIZE_HEIGHT) # create a blank 'canvas' image
      # paste the item into our blank image
      final_image = canvas.composite(new_proportion_image, Magick::CenterGravity, Magick::OverCompositeOp)

      complete_file_path = "#{IMAGE_FILE_LOCATION}/#{rand(36**8).to_s(36)}.#{magick_image.format.downcase}"
      final_image.write(complete_file_path)

      # clear image from memory. var will be assigned to #<Magick::Image: (destroyed)>
      [new_proportion_image, canvas, final_image].each { |img| img.destroy! }
    rescue Exception => e
      complete_file_path = "resize_image error: #{e}"
    end
    complete_file_path
  end

  # TODO - resize_image writes img to disk, and then carrierwave does to (to /tmp)
  def save_item_from_url(item_object)
    begin
      image_url = item_object[:image_source]
      magick_image = get_image(image_url)
      image_path = resize_image(magick_image)
      item_object[:image_source] = open(image_path)

      response = Item.create!(item_object)
      [image_path, response.image_source.path].each { |f| File.delete f }
    rescue ActiveRecord::RecordInvalid => e
      response = e
    end
    response
  end

end

