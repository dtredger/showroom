class RemoveImageFieldsFromItem < ActiveRecord::Migration
  def change
    remove_column :items, :image_source, :text
    remove_column :items, :image_source_array, :text
  end
end
