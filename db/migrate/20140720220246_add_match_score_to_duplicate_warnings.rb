class AddMatchScoreToDuplicateWarnings < ActiveRecord::Migration
  def change
  	remove_column :duplicate_warnings, :is_identical_match, :boolean
  	add_column :duplicate_warnings, :match_score, :integer
  end
end
