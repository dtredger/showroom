	require_relative 'BasicScraper'

	class TresbienScraper < BasicScraper

    STORE_NAME = "Tres Bien"
    CURRENCY = "EURO"
    STATE = 0
    SITE_ROOT = "http://tres-bien.com"


    def begin_scrape(url, category="", is_test)
      pages = find_number_of_pages(url)
      pages = [pages[0]] if is_test
      pages.each do |page_url|
        results = scrape_category_page(page_url, category, is_test)
        puts results
      end
    end

		def find_number_of_pages(url)
			dom = open_url(url)
			links_array = []

			pages = dom.css('.pages')
			if pages.empty?
				links_array = [url]
			else
				links = pages.css('a')
				links.each { |link| links_array << link[:href] unless links_array.include?(link[:href]) }
			end
			links_array
		end

		def scrape_category_page(url, category1, is_test)
      dom = open_url(url)
      items = dom.css('.rect')
      items = items[-3..-1] if is_test

      results_log = { success: 0, failure: 0 }
      errors_log = []
      success_log = []

      items.each do |item|
        begin
          product = {
            product_name: item.at_css('.product-name').text.strip,
            price_cents: price_to_cents(item.at_css('.regular-price').text),
            currency: CURRENCY,
            store_name: STORE_NAME,
            image_source: item.at_css('img')['data-retina-src'],
            state: STATE,
            product_link: SITE_ROOT + item.at_css('a')[:href],
            category1: category1
          }
          complete_product = scrape_product_page(product)
          saved = save_item_from_url(complete_product)
          results_log[:success] += 1
          success_log << saved.id
        rescue Exception => e
          results_log[:failure] += 1
          errors_log << e
          next
        end
      end
      [results_log, "success IDs:", success_log, "errors:", errors_log]
    end

		def scrape_product_page(product)
      begin
			  product_page = open_url(product[:product_link])
        description = product_page.at_css('#product-description').text.gsub('"', '').strip
        designer = product_page.css('.product-info-container h2').text.strip

        # remove designer name from product name
        product[:product_name] = product[:product_name].gsub(designer, "")

        images = product_page.css('.shadowbox img')
        image_array = []
        images.each { |image| image_array << image[:src] }

        product.store("designer", designer)
        product.store("description", description)
        product.store("image_source_array", image_array)
        response = product
      rescue Exception => e
        response = "scrape_product_page error: #{e}"
      end
      response
    end


	end
