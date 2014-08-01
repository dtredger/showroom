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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :duplicate_warning do
  end
end
