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
	# belongs_to :existing_item, class_name: "Item"

  validates :pending_item_id, presence: true
  validates :existing_item_id, presence: true

  validates_uniqueness_of :pending_item_id,
            scope: :existing_item_id

  # TODO - absent uniqueness validation, PG error raised:
  # ActiveRecord::RecordNotUnique: PG::UniqueViolation: ERROR:  duplicate key value violates unique constraint "by_pending_existing"
  # DETAIL:  Key (pending_item_id, existing_item_id)=(12, 1) already exists.
end
