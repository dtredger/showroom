class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :product_name
      t.text :description
      t.text :designer
      t.integer :price_cents
      t.string :currency
      t.string :store_name
      t.text :image_source
      t.text :image_source_array
      t.text :product_link
      t.string :category1
      t.string :category2
      t.string :category3
      t.integer :state

      t.timestamps
    end
  end
end
