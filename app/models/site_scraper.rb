# == Schema Information
#
# Table name: site_scrapers
#
#  id                           :integer          not null, primary key
#  store_name                   :string
#  detail_product_name_selector :string
#  detail_description_selector  :string
#  detail_designer_selector     :string
#  detail_price_cents_selector  :string
#  detail_currency_selector     :string
#  detail_image_source_selector :string
#  index_product_link_selector  :string
#  detail_category_selector     :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  index_product_name_selector  :string
#  index_designer_selector      :string
#  index_category_selector      :string
#  index_item_group_selector    :string
#  index_price_cents_selector   :string
#

class SiteScraper < ActiveRecord::Base

  include Scrapeable

  def scrape_index(html_dom, is_test=false)
    items = html_dom.css(self.index_item_group_selector)
    items = items[-3..-1] if is_test

    results_log = { success: 0, failure: 0 }
    errors_log = []
    success_log = []

    items.each do |item|
      # log errors but keep going with other rows
      begin
        product_name = self.index_product_name_selector.present? ? item.at_css(self.index_product_name_selector).text.strip : ""
        designer = self.index_designer_selector.present? ? item.at_css(self.index_designer_selector).text.strip.upcase : ""
        category = self.index_category_selector.present? ? item.at_css(self.index_category_selector) : ""
        price = self.index_price_cents_selector.present? ? item.at_css(self.index_price_cents_selector).text : ""
        # Don't need the others, but blank product_link is deal-breaker
        product_link = item.at_css(self.index_product_link_selector)[:href]
        saved = Item.create(
            store_name: self.store_name,
            product_link: product_link,
            product_name: product_name,
            price_cents: price_to_cents(price),
            designer: designer,
            category1: category,
            state: "incomplete"
        )
        results_log[:success] += 1
        success_log << saved.id
      rescue Exception => e
        results_log[:failure] += 1
        errors_log << e
        next
      end
    end
    [results_log, success_log, errors_log]
  end

  # def scrape_detail_page(product)
  #   begin
  #     product_page = open_url(product[:product_link])
  #
  #     product.store(:description, product_page.css(".product-description").css("p").text.strip)
  #
  #     image_node_array = product_page.css(".product-thumbnail").css("img")
  #     image_array = []
  #     image_node_array.each { |img| image_array << img[:src] }
  #     product.store(:image_source_array, image_array)
  #     response = product
  #   rescue Exception => e
  #     response = "scrape_product_page error: #{e}"
  #   end
  #   response
  # end


end
