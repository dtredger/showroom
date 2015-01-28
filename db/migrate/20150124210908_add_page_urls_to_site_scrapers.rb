class AddPageUrlsToSiteScrapers < ActiveRecord::Migration
  def change
    add_column :site_scrapers, :page_urls, :text
  end
end
