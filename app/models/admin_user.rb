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
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class AdminUser < ActiveRecord::Base

  # devise validatable min-length is 4, set in devise.rb
  # validates :password, length: { minimum: 4 }

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable


  def login=(login)
    @login = login
  end

  def login
    @login || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(email) = :value", {value: login.strip.downcase}]).first
  end


end
