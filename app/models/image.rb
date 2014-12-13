# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  source     :string(255)
#  item_id    :integer
#

class Image < ActiveRecord::Base
  belongs_to :item

  mount_uploader :source, ItemImageUploader

  validates_presence_of :source
  validates_presence_of :item

  validates_associated :item

  # TODO - items with an identical path (.source.path) will cause the
  # uploader to overwrite, or error: there should be a check (likely
  # on the uploader itself) for duplicate images
  # validates_uniqueness_of :source


end


