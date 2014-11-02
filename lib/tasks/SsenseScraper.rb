require_relative "BasicScraper"

class SsenseScraper < BasicScraper

  SITE_ROOT = "https://www.ssense.com"
  STORE_PROTOCOL = "https:"
  STORE_NAME = "Ssense"
  CURRENCY = "CAD"
  STATE = ""

  def begin_scrape(url, category="", is_test)
    dom = open_url(url)
    results = scrape_category_page(dom, category, is_test)
    puts results
  end

  def scrape_category_page(dom, *categories, is_test) # splat operator used on categories
    items = dom.css(".span-one-quarter")
    items = items[-3..-1] if is_test

    results_log = { success: 0, failure: 0 }
    errors_log = []
    success_log = []

    items.each do |item|
      # log errors but keep going with other rows
      begin
        product_hash = {
          product_name: item.at_css(".product-name").text.strip,
          designer: item.at_css(".product-designer").text.strip.upcase,
          price_cents: price_to_cents(item.css(".product-price").text),
          currency: CURRENCY,
          store_name: STORE_NAME,
          image_source: item.at_css("img")["data-src"],
          product_link: SITE_ROOT + item.at_css("a")[:href]
        }
        complete_product = scrape_product_page(product_hash)
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

      product.store(:description, product_page.css(".product-description").css("p").text.strip)

      image_node_array = product_page.css(".product-thumbnail").css("img")
      image_array = []
      image_node_array.each { |img| image_array << img[:src] }
      product.store(:image_source_array, image_array)
      response = product
    rescue Exception => e
      response = "scrape_product_page error: #{e}"
    end
    response
  end

end
