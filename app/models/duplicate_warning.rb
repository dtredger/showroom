# == Schema Information
#
# Table name: duplicate_warnings
#
#  id               :integer          not null, primary key
#  pending_item_id  :integer
#  existing_item_id :integer
#  warning_notes    :text
#  created_at       :datetime
#  updated_at       :datetime
#  match_score      :integer
#

class DuplicateWarning < ActiveRecord::Base
	belongs_to :pending_item, class_name: "Item"
	belongs_to :existing_item, class_name: "Item"

  validates :pending_item_id, presence: true
  validates :existing_item_id, presence: true
end
