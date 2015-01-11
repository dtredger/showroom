ActiveAdmin.register SiteScraper do

  config.filters = false

  permit_params :store_name,
      :index_product_link_selector,
      :index_product_name_selector,
      :index_designer_selector,
      :index_category_selector,
      :index_item_group_selector,
      :index_price_cents_selector,
      :detail_product_name_selector,
      :detail_description_selector,
      :detail_designer_selector,
      :detail_price_cents_selector,
      :detail_currency_selector,
      :detail_image_source_selector,
      :detail_category_selector

end