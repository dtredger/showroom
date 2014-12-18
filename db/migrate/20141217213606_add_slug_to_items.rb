class AddSlugToItems < ActiveRecord::Migration
  def change
    add_column :items, :slug, :string, null: false

    add_index :items, :slug, unique: true
  end
end
