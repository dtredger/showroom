class ClosetsItem < ActiveRecord::Base

	belongs_to :closet
	belongs_to :item

  validates_presence_of :closet_id
  validates_presence_of :item_id
end
