class CreateDeadpoolWarnings < ActiveRecord::Migration
  def change
    create_table :deadpool_warnings do |t|
      t.integer :item_id
      t.integer :score
      t.text :warning_notes

      t.timestamps
    end
  end
end
