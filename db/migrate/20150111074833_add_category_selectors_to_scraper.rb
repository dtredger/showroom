class AddCategorySelectorsToScraper < ActiveRecord::Migration
  def change
    rename_column :site_scrapers, :store_name_selector, :store_name

    rename_column :site_scrapers, :product_name_selector, :detail_product_name_selector
    rename_column :site_scrapers, :description_selector, :detail_description_selector
    rename_column :site_scrapers, :designer_selector, :detail_designer_selector
    rename_column :site_scrapers, :price_cents_selector, :detail_price_cents_selector
    rename_column :site_scrapers, :currency_selector, :detail_currency_selector
    rename_column :site_scrapers, :image_source_selector, :detail_image_source_selector
    rename_column :site_scrapers, :category_selector, :detail_category_selector

    rename_column :site_scrapers, :product_link_selector, :index_product_link_selector

    add_column :site_scrapers, :index_product_name_selector, :string
    add_column :site_scrapers, :index_designer_selector, :string
    add_column :site_scrapers, :index_category_selector, :string
  end
end
