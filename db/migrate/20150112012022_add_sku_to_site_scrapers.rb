class AddSkuToSiteScrapers < ActiveRecord::Migration
  def change
    add_column :site_scrapers, :sku, :string
  end
end
