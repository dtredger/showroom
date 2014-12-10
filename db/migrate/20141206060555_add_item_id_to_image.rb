class AddItemIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :item_id, :integer
  end
end
