class CreateClosets < ActiveRecord::Migration
  def change
    create_table :closets do |t|
      t.integer :item_id
      t.integer :user_id
      t.string :title
      t.text :summary

      t.timestamps
    end
  end
end
