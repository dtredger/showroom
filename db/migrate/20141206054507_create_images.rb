class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t
      t.timestamps
    end
  end
end
