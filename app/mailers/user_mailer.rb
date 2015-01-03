class UserMailer < ApplicationMailer

  def new_user(user)
    @user = user
    mail to: user.email, subject: "Hello!"
  end

end
