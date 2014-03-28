class User < ActiveRecord::Base

  validates :username,
    :uniqueness => {
      :case_sensitive => false
    }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def update_facebook_info(auth)
  	self.fb_token = auth.credentials.fb_token
  	self.fb_expires_at = Time.at(auth.credentials.expires_at)
  	self.fb_uid = auth.uid if self.fb_uid.nil?
  	save
  end

  # Added to allow users to signin via username or email
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
