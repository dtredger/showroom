# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  fb_uid                 :string(255)
#  fb_token               :string(255)
#  fb_token_expiration    :datetime
#  username               :string(255)
#  slug                   :string(255)      not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    username "username"
    email "user@email.com"
    password "user_password"
    # confirmed_at Time.now()

    factory :user_2 do
      username "username_2"
      email "user_2@email.com"
      password "user2_password"
    end

    factory :invalid_user do
      username "whatever"
      email "not an email"
      password ""
    end

    factory :unique_user do
      sequence(:username) { |i| "unique-username-#{i}" }
      sequence(:email) { |i| "unique-email-#{i}@email-#{i}.com" }
      sequence(:password) { |i| "unique-pass-#{i}" }
    end
  end

  factory :facebook_user do
    fb_token 'TOKEN_OAUTH_2' # OAuth 2.0 access_token, which you may wish to store
    fb_expires_at 1521747205 # when the access token expires (it always will)
  end




end

