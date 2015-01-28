class CreateSiteScrapers < ActiveRecord::Migration
  def change
    create_table :site_scrapers do |t|
      t.string :store_name_selector

      t.string :product_name_selector
      t.string :description_selector
      t.string :designer_selector
      t.string :price_cents_selector
      t.string :currency_selector

      t.string :image_source_selector
      t.string :product_link_selector
      t.string :category_selector

      t.timestamps null: false
    end
  end
end
