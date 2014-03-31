class ClosetsItemsJoinTable < ActiveRecord::Migration

	def self.up
		create_table 'closets_items', :id => false do |t|
			t.column 'closet_id', :integer
			t.column 'item_id', :integer
		end
	end

	def self.down
		drop_table 'closets_items'
	end
end
