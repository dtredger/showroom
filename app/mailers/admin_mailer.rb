class AdminMailer < ApplicationMailer

  def jobs_notifier(admin_user, message)
    @message = message
    mail to: admin_user.email, subject: "Background Jobs Update"
  end

  def error_notifier(admin_user, error)
    @error = error
    mail to: admin_user.email, subject: "Showspace error"
  end

end
