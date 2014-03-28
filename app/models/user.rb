class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  def update_facebook_info(auth)
  	self.fb_token = auth.credentials.fb_token
  	self.fb_expires_at = Time.at(auth.credentials.expires_at)
  	self.fb_uid = auth.uid if self.fb_uid.nil?
  	save
  end

end
