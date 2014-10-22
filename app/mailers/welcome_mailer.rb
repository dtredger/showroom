class WelcomeMailer < ActionMailer::Base
  default from: "from@example.com"


  def welcome_email(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "hello")
  end

end
