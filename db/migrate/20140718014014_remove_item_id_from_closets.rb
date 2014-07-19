class RemoveItemIdFromClosets < ActiveRecord::Migration
  def change
    remove_column :closets, :item_id, :integer
  end
end
