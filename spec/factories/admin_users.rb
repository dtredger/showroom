# == Schema Information
#
# Table name: admin_users
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
#  carrier                :string
#  sms_gateway            :string
#  phone_number           :string
#  send_notifications     :boolean
#

FactoryGirl.define do
  factory :admin_user do
    email 'admin@show.co'
    password 'admin_password'


    factory :admin_user_2 do
      email 'admin-2@email.com'
      password 'admin-2-password'
    end

    factory :admin_with_SMS do
      email 'admin-sms@email.com'
      password 'admin-2-password'
      phone_number "1234567890"
      carrier "Bell"
    end
  end

end
