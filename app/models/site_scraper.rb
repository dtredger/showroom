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

    results_log = { success: 0, not_saved: 0, failure: 0 }
    success_log = []
    not_saved_log = []
    errors_log = []

    items.each do |item|
      begin
        product_name = if self.index_product_name_selector.present? then
                         eval("item.#{self.index_product_name_selector}")
                       else
                         ""
                       end
        designer = if self.index_designer_selector.present? then
                     eval("item.#{self.index_designer_selector}")
                   else
                     ""
                   end
        category = if self.index_category_selector.present? then
                     eval("item.#{self.index_category_selector}")
                   else
                     ""
                   end
        price = if self.index_price_cents_selector.present? then
                  eval("item.#{self.index_price_cents_selector}")
                else
                  ""
                end

        # Don't need the others, but blank product_link is deal-breaker
        product_link = eval("item.#{self.index_product_link_selector}")

        # TODO remove temporary tresbien hack
        if product_link[0..3] != "http"
          if self.store_name == "tresbien"
            product_link = "http://tres-bien.com#{product_link}"
          end
        end

        new_item = Item.create(
            store_name: self.store_name,
            product_link: product_link,
            product_name: product_name,
            price_cents: price_to_cents(price),
            designer: designer,
            category1: category,
            state: "incomplete"
        )
        if new_item.persisted?
          results_log[:saved] += 1
          success_log << new_item.id
        elsif new_item.errors.any?
          new_item.errors.messages.each do |key, val|
            results_log[:not_saved] += 1
            not_saved_log << "#{key} - #{val}"
          end
        end
      rescue Exception => e
        results_log[:failure] += 1
        errors_log << e
        next
      end
    end
    { results: results_log, success: success_log, not_saved: not_saved_log, errors: errors_log }
  end

  def self.scrape_detail_page(scraper, product)
    new_fields = {}
    page = product.open_url(product[:product_link])
    %w(product_name description designer currency sku).each do |field|
      new_fields["#{field}".to_sym] = if scraper["detail_#{field}_selector".to_sym].present? then
                                        eval("page.#{scraper["detail_#{field}_selector".to_sym]}")
                                      else
                                        ""
                                      end
    end

    # TODO - someday we will get rid of category1, category2, category3
    new_fields[:category1] = if scraper.index_category_selector.present? then
                               eval("page.#{scraper.detail_category_selector}")
                             else
                               ""
                             end

    image_array = if scraper.detail_image_source_selector.present? then
                    eval("page.#{scraper.detail_image_source_selector}")
                  else
                    ""
                  end

    # TODO - having items created in initial scrape means check_for_duplicate runs then,
    # not now, when it would actually be useful
    if product.update(new_fields)
      image_array = [image_array] unless image_array.is_a?(Array)
      image_results = product.save_images(image_array, true)
      unless product[:price_cents].blank? or product.images.count == 0
        # TODO check more than this, before setting live
        product.update(state:"pending")
        return [:success, product.id]
      end
      [:no_image, product.id]
    else
      [:not_updated, product.id]
    end

  end

  def page_urls
    self[:page_urls].split(",")
  end


end
