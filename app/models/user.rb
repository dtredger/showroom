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
#  sign_in_count          :integer          default(0), not null
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

class User < ActiveRecord::Base

  include FriendlyId
  friendly_id :slug_candidates, use: :slugged


  has_many :items, through: :closets
  has_many :closets, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  # Devise has default email and password validations
  validates :username,
            uniqueness: { case_sensitive: false },
            presence: true

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  before_validation :create_username
  after_create :make_a_closet

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login


  # http://norman.github.io/friendly_id/file.Guide.html
  def slug_candidates
    [ :username, :email ]
  end

  # def should_generate_new_friendly_id?

  # end


  # Override Devise's password_required?
  # Check if a password is required for the registration process.
  # A password is not required if the user registers via Facebook.
  def password_required?
    # If Devise's super method returns false or nil, fb_uid.blank? is not evaluated.
    # Otherwise return boolean fb_uid.blank?
    super && fb_uid.blank?
  end

  # Update the user's record with the new Facebook info
  def update_facebook_info(auth)
    fb_token = auth[:credentials][:token]
    fb_expires_at = Time.at(auth[:credentials][:expires_at])
    update(fb_token: fb_token, fb_token_expiration: fb_expires_at)
  end

  # NOTE:
  # We could override new_with_session instead of modifying RegistrationsController logic
  # Currently I favored the more explicit approach. This method could be overridden later.
  def self.new_with_session(params, session)
    super
  end

  def make_a_closet
    self.closets.create(title: "My Closet", summary: "My first closet")
  end

  # Added to allow users to sign in via username or email
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value",
           { value: login.downcase }]
      ).first
    else
      # TODO - how do we get to this else block?
      # safer to use User.none  ??
      where(conditions).first
    end
  end

  def create_username
    if self.username.blank?
      self.update(username: self.email)
    end
  end

  # send devise emails via active-job (async)
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

end
