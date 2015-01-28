class AddIndexPriceSelectorToSiteScrapers < ActiveRecord::Migration
  def change
    add_column :site_scrapers, :index_price_cents_selector, :string
  end
end
