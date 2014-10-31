require_relative 'BasicScraper'

class MrPorterScraper < BasicScraper
  TEST_MODE = true
  SITE_ROOT = "http://www.mrporter.com"
  URL_PROTOCOL = "http:"
  CURRENCY = "USD"
  STORE_NAME = "Mr. Porter"
  STATE = 0

  # TODO - is this relevant, if we can simply ?viewall=on
  # def find_number_of_pages(url)
		# page = open_url(url)
  #
  #  # parse ul that counts "Page x of y"
		# page_count_string = page.css('.product-list-menu-page-filter').at_css('.page-on').text.strip
  #  page_count = /of.(?<count>\d*)/.match(page_count_string)[:count].to_i
  #
		# # grab the next page link stored in 3rd li element
		# page_link = pages.css('li')[2].at_css('a')[:href]
  #
		# @base_url = "http://www.mrporter.com/" + page_link[0...-1] # chop off last number from url
		# puts "Base url: " + @base_url
  # end

  def begin_scrape(url, category="")
    dom = open_url(url)
    results = scrape_category_page(dom, category)
    puts results
  end

	def scrape_category_page(dom, category)
    item_details = dom.css('.description')
    images = dom.css('.tall-product-image')

    if item_details.length != images.length
      puts "Fatal: image rows doesn't match detail rows"
      exit
    end

    results_log = { success: 0, failure: 0 }
    errors_log = []

    beginning = (images.length - 3) if TEST_MODE
    ((beginning||=0)..images.length).each do |row|
      # log errors but keep going with other rows
      begin
        product = {
            product_link: SITE_ROOT + images[row].at_css('a')['href'],
            image_source: URL_PROTOCOL + images[row].at_css('img')['src'],
            designer: item_details[row].at_css('.product-designer').text.strip.upcase,
            product_name: item_details[row].at_css('.product-title').text.strip,
            price_cents: item_details[row].at_css('.price-container').text.strip.gsub("$", '').gsub(",", ''),
            category1: category
        }
        complete_product = scrape_product_page(product)
        save_item_from_url(complete_product)
        results_log[:success] += 1
      rescue Exception => e
        results_log[:failure] += 1
        errors_log << e
        next
      end
    end
    [results_log, errors_log]
	end

	def scrape_product_page(product_object)
    begin
      product_page = open_url(product_object[:product_link])

      # the image_array for MrPorter has one image
      image = URL_PROTOCOL + product_page.css('#medium-image').at_css('img')['src']

      meta_desc = product_page.at("meta[property='og:description']")
      description = meta_desc['content'].strip

      product_object.store(:image_source_array, [image])
      product_object.store(:description, description)
      product_object.store(:currency, "USD")
      product_object.store(:store_name, "Mr. Porter")
      product_object.store(:state, 0)
      response = product_object
    rescue Exception => e
      response = "scrape_product_page error: #{e}"
    end
    response
	end


end

