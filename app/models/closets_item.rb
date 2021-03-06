# == Schema Information
#
# Table name: closets_items
#
#  closet_id :integer
#  item_id   :integer
#

class ClosetsItem < ActiveRecord::Base
	belongs_to :closet
	belongs_to :item

  validates_presence_of :closet_id
  validates_presence_of :item_id

  validates_uniqueness_of :item_id,
      scope: :closet_id

end
