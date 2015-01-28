class AddIndexItemGroupSelectorToScraper < ActiveRecord::Migration
  def change
    add_column :site_scrapers, :index_item_group, :string
  end
end
