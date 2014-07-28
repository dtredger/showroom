#
# Scraper no longer seems to work
#
#
#

require_relative 'BasicScraper'

class SsenseScraper < BasicScraper

    def category_scrape(url, *categories) # splat operator used on categories
      urls = find_number_of_pages(url)
      urls.each do |url|
        open_url(url)

        items = @site.css('.cp_item')

        items.each do |item|
          product_hash = Hash.new
          product_hash.store("category1", categories[0]) if categories[0]
          product_hash.store("category2", categories[1]) if categories[1]

          product_link = item.at_css('a')['href']
          product_image_link = item.at_css('img')['src']
          designer = item.at_css('p').text.strip.upcase if !item.at_css('p').nil?
          name = item.css('p')[1].text.strip if !item.css('p')[1].nil?
          if !item.css('p')[2].nil?
            price = item.css('p')[2].text
            price = price.gsub('"', '')
            price = price.strip
              price = price.gsub("$", '') # strip dollar sign
            end

            puts "designer: " + designer
            puts "name: " + name
            puts "price: " + price
            puts "product link: " + product_link
            puts "image link: " + product_image_link

            product_hash.store("store_name", "Ssence")
            product_hash.store("designer", designer)
            product_hash.store("product_name", name)
            product_hash.store("price", price)
            product_hash.store("currency", "CAD")
            product_hash.store("product_link", product_link)
            product_hash.store("image_source", product_image_link)
            @items_array << product_hash
          end
        end
      end

      def scrape_items_detail
        @items_array.each do |item|
          open_url(item["product_link"])

          description = @site.at_css('.desc').text.strip
          images = @site.css('.product_imgs')
          images = images.css('img')

          image_array = Array.new
          images.each do |image|
            image_array << image['src']
          end
          item.store("image_source_array", image_array)
          item.store("description", description)

        resize_image(item) # resize images

        puts "detail scrape - images_array: " + image_array.inspect
        puts "detail scrape - description: " + description
      end
    end

    # def resize_image(item_hash)
    #   image_smaller = Magick::ImageList.new
    #   url_smaller = open(item_hash["image_source"])
    #   image_smaller.from_blob(url_smaller.read)
    #   puts "SMALLER X-RES: " + image_smaller[0].columns.to_s 
    #   puts "SMALLER  Y-RES: " + image_smaller[0].rows.to_s 

    #   if image_smaller[0].columns < 280
    #     image_bigger = Magick::ImageList.new
    #     url_bigger = open(item_hash["image_source_array"][0])
    #     image_bigger.from_blob(url_bigger.read)

    #     store_path = "/Users/admin/Desktop/assignments/showroom/showroom/app/assets/images/product_icons/" + format_url_to_filename(item_hash["image_source_array"][0])

    #     if image_bigger[0].columns > 280
    #       puts "BIGGER X-RES: " + image_bigger[0].columns.to_s
    #       puts "BIGGER Y-RES: " + image_bigger[0].rows.to_s

    #       image_ratio = Float.new
    #         image_ratio = 280 / image_bigger[0].columns # small / large
    #         image_length = image_bigger[rows] * image_ratio
    #         iamge_legnth = image_length.round.to_i

    #         image_bigger.resize_to_fit(280, image_length)

    #         image_bigger.write(store_path)
    #         image_bigger.destroy! # clear image from memory

    #       elsif image_bigger[0].columns == 280
    #         # save image locally as it is
    #         image_bigger.write(store_path)
    #         image_bigger.destroy! # clear image from memory
    #       else
    #         puts "fatal error in resizing"
    #         puts "BIGGER X-RES: " + image_bigger[0].columns.to_s
    #         puts "BIGGER Y-RES: " + image_bigger[0].rows.to_s
    #         image_bigger.destroy!
    #         abort
    #       end
    #     end
    #     image_smaller.destroy! # clear image from memory
    #   end

      def add_items_to_database
       #products = Item.all
       #products = products.where("store_name LIKE ?", "%#{@items_array[0]['store_name']}%")

       @items_array.each do |item|
       #  next if products.includes("product_link = ?", item['product_link']) # basic check to see if product is in DB

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

def find_number_of_pages(url)
  puts "Finding the number of pages"
  open_url(url)
  links_array = Array.new

    pages = @site.css('.numbers') # the result will be an array

    # note that this method of scraping ssense will only work for categories with less than 7 pages
    # fortunately categories are not expected to exceed 7 pages

    if pages.empty? || pages.nil?
      puts "One page found:"
      puts "adding url: " + url
      links_array << url
    else
      puts "Multiple pages found:"
      links = pages.css('a')
      links.each do |link|
        if !links_array.include?(link['href'])
          puts "adding url: " + link['href']
          links_array << link['href']
        end
      end
    end
    return links_array
  end
end
