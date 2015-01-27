class RenameIndexItemGroup < ActiveRecord::Migration
  def change
    rename_column :site_scrapers, :index_item_group, :index_item_group_selector
  end
end
