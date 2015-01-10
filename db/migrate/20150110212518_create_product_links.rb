class CreateProductLinks < ActiveRecord::Migration
  def change
    create_table :product_links do |t|

      t.timestamps null: false
    end
  end
end
