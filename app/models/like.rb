# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Like < ActiveRecord::Base
	belongs_to :likeable, polymorphic: :true
end
