class DuplicateWarning < ActiveRecord::Base
	belongs_to :pending_item, class_name: "Item"
	belongs_to :existing_item, class_name: "Item"

  validates :pending_item_id, presence: true
  validates :existing_item_id, presence: true
end