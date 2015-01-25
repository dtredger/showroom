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
#  sku                          :string
#  page_urls                    :text
#

class SiteScraper < ActiveRecord::Base

  include Scrapeable

  def scrape_index(page_url, is_test=false)
    html_dom = open_url(page_url)
    items = eval("html_dom.#{self.index_item_group_selector}")
    items = items[-3..-1] if is_test

    results_log = { success: 0, failure: 0 }
    errors_log = []
    success_log = []

    items.each do |item|
      # log errors but keep going with other rows
      begin
        product_name = self.index_product_name_selector.present? ? eval("item.#{self.index_product_name_selector}") : ""
        designer = self.index_designer_selector.present? ? eval("item.#{self.index_designer_selector}") : ""
        category = self.index_category_selector.present? ? eval("item.#{self.index_category_selector}") : ""
        price = self.index_price_cents_selector.present? ? eval("item.#{self.index_price_cents_selector}") : ""
        # Don't need the others, but blank product_link is deal-breaker
        product_link = eval("item.#{self.index_product_link_selector}")
        if product_link[0..3] != "http"
          if self.store_name == "tresbien"
            product_link = "http://tres-bien.com#{product_link}"
          end
        end

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

  def self.scrape_detail_page(scraper, product)
    new_fields = {}
    page = product.open_url(product[:product_link])
    %w(product_name description designer currency sku).each do |field|
      new_fields["#{field}".to_sym] = scraper["detail_#{field}_selector".to_sym].present? ? eval("page.#{scraper["detail_#{field}_selector".to_sym]}") : ""
    end

    # TODO - someday we will get rid of category1, category2, category3
    new_fields[:category1] = scraper.index_category_selector.present? ? eval("page.#{scraper.detail_category_selector}") : ""
    image_array = scraper.detail_image_source_selector.present? ? eval("page.#{scraper.detail_image_source_selector}") : ""
    # TODO - having items created in initial scrape means check_for_duplicate runs then,
    # not now, when it would actually be useful
    result = product.update(new_fields)

    # TODO scraper should return array
    image_array = [image_array] unless image_array.is_a?(Array)
    image_results = product.save_images(image_array, true)
    unless product[:price_cents].blank? or product.images.count == 0
      # TODO check more than this, before setting live
      product.update(state:"pending")
    end
    [result, image_results]
    # TODO - above is returning
    # [[true, [[nil], []]], [true, [[nil], []]],...
  end

  def page_urls
    self[:page_urls].split(",")
  end


end
