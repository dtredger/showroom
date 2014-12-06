# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  image      :string(255)
#  item_id    :integer
#

FactoryGirl.define do
  factory :image do
    
  end

end
