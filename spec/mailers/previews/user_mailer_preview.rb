class UserMailerPreview < ActionMailer::Preview

  def new_user
    user = User.first
    UserMailer.new_user(user)
  end

end