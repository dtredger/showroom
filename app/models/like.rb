# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Like < ActiveRecord::Base
	belongs_to :likeable, polymorphic: :true

  validates_presence_of :likeable_id
  validates_presence_of :likeable_type
end
