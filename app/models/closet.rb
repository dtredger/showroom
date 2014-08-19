# == Schema Information
#
# Table name: closets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  summary    :text
#  created_at :datetime
#  updated_at :datetime
#

class Closet < ActiveRecord::Base
  has_and_belongs_to_many :items
  belongs_to :user

	validates_presence_of :title
  validates_uniqueness_of :title, scope: :user_id


end
