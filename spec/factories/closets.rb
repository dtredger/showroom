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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :closet do
  end
end
