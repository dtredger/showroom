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
    association :user, factory: :user, username: "username"
    title "closet one"
    summary "summary for closet one"

    factory :closet_2 do
      association :user, factory: :user, username: "username_2"
      title "closet two"
    end

    factory :closet_3 do
      association :user, factory: :user, username: "username"
      title "second closet for user one "
      summary "user one's second closet "
    end

    factory :unique_closet do
      sequence(:title) { |i| "closet title #{i}" }
      sequence(:summary) { |i| "closet summary #{i}" }
    end
  end
end
