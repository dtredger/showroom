class CreateDuplicateWarnings < ActiveRecord::Migration
  def change
    create_table :duplicate_warnings do |t|
      t.integer :pending_item_id
      t.integer :existing_item_id
      t.boolean :is_identical_match
      t.text :warning_notes

      t.timestamps
    end
    add_index :duplicate_warnings, :pending_item_id
    add_index :duplicate_warnings, :existing_item_id
    # http://stackoverflow.com/questions/5443740/how-to-handle-too-long-index-names-in-a-rails-migration-with-mysql
    add_index :duplicate_warnings, [:pending_item_id, :existing_item_id], unique: true, name: 'by_pending_existing'
  end
end
