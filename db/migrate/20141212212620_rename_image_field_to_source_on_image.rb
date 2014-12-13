class RenameImageFieldToSourceOnImage < ActiveRecord::Migration
  def change
    rename_column :images, :image, :source
  end
end
