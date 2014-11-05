class AdminUser < ActiveRecord::Base

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
    where(conditions).where(["lower(email) = :value", { :value => login.strip.downcase }]).first
  end


end