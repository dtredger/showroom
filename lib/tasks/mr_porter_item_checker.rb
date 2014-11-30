# http://stackoverflow.com/questions/19393276/how-to-tell-when-rubys-openuri-open-function-gives-a-404-page-not-found-error
# http://genius.com/2617070/Genius-founders-rap-genius-is-back-on-google/Open-uri-is-probably-the-easiest-way-to-download-a-url-in-ruby
# http://www.somethingsimilar.com/2007/08/08/openuri-exceptions-and-http-status-codes/
require 'nokogiri'
require 'open-uri'
require 'time'
require 'pry'
require 'fileutils'

class MrPorterItemChecker

	FAKE_UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0.1"

  def open_url(item)
    begin
      dom = Nokogiri::HTML(open(page_url, "User-Agent" => FAKE_UA))
    rescue OpenURI::HTTPError => e
    	# Check status code returned
    	# http://www.somethingsimilar.com/2007/08/08/openuri-exceptions-and-http-status-codes/
    	if e.io.status[0] == 404
				if item.deadpool_warning.nil?
					item.create_deadpool_warning(score: 100, warning_notes: "404")
				else
					item.deadpool_warning.update_attribute(score: 100)
					item.deadpool_warning.update_attribute(warning_notes: "404")
				end
    	end
    	dom = e
    # http://jerodsanto.net/2008/08/ruby-to-the-rescue/
    rescue Timeout::Error
    	# Page timed out
    	dom = e
    rescue OpenURI::Error
    	# Other errors
    	dom = e
    end
    dom
  end

  def check_items
  	items = Item.where(state: 1).where(store_name: "Mr. Porter")

  	items.each do |item|
			dom = open_url(item.product_link)

			# http://stackoverflow.com/questions/15769739/determining-type-of-an-object-in-ruby
			next if dom.is_a?(Exception)

			# Otherwise check page for info
			# do a basic search for product name anywhere on page?
			# page.text.include?
			# page.search...

			# http://stackoverflow.com/questions/6129357/getting-viewable-text-words-via-nokogiri
			if !dom.at('body').inner_text.includes? item.product_name

				if item.deadpool_warning.nil?
					item.create_deadpool_warning(score: 50, warning_notes: "Product name not found!")
				else
					item.deadpool_warning.update_attribute(score: 50)
					item.deadpool_warning.update_attribute(warning_notes: "Product name not found!")
				end
			end

  	end
  end

end