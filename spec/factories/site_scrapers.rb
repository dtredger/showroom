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

sample_url = Rails.root.join("spec/factories/store_scrapes/tres_bien_outerwear.html").to_s

FactoryGirl.define do
  factory :site_scraper do
    store_name "test"
    page_urls sample_url
    index_item_group_selector "css('li.rect')"
    index_product_name_selector "at_css('h2.product-name').text.strip"
    index_designer_selector ""
    index_category_selector ""
    index_product_link_selector "at_css('a')[:href]"
    index_price_cents_selector "css('span').text.strip.split(' ').last"
    # detail page selectors
    detail_product_name_selector ""
    detail_description_selector ""
    detail_designer_selector "at_css('.product-designer')"
    # TODO - should be new- and old-price selectors
    detail_price_cents_selector "at_css('.special-price .price').text.strip"
    # old_price: "at_css('.old-price .price')"
    detail_currency_selector ""
    detail_image_source_selector "at_css('.action-image-active')[:src]"
    detail_category_selector ""
  end

end
