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
        product_name = self.index_product_name_selector.present? ? eval("item.#{self.index_product_name_selector}") : ""
        designer = self.index_designer_selector.present? ? eval("item.#{self.index_designer_selector}") : ""
        category = self.index_category_selector.present? ? eval("item.#{self.index_category_selector}") : ""
        price = self.index_price_cents_selector.present? ? eval("item.#{self.index_price_cents_selector}") : ""
        # Don't need the others, but blank product_link is deal-breaker
        product_link = eval("item.#{self.index_product_link_selector}")
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

  def scrape_detail_page(product)
    page = open_url(product[:product_link])
    new_fields = { state: "pending" }
    %w(product_name description designer currency sku).each do |field|
      new_fields["#{field}".to_sym] = self["detail_#{field}_selector".to_sym].present? ? eval("page.#{self["detail_#{field}_selector".to_sym]}") : ""
    end
    # TODO - someday we will get rid of category1, category2, category3
    new_fields[:category1] = self.index_category_selector.present? ? eval("page.#{self.detail_category_selector}") : ""
    image_array = self.detail_image_source_selector.present? ? eval("page.#{self.detail_image_source_selector}") : ""
    product.update(new_fields)
    save_images(product, [image_array], true)
  end


end
