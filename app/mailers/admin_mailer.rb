class AdminMailer < ApplicationMailer

  def jobs_notifier(admin_user, message)
    @message = message
    mail to: admin_user.email, subject: "Background Jobs Update"
  end

  def error_notifier(admin_user, error)
    @error = error
    mail to: sms_or_email(admin_user), subject: "Showspace error"
  end


  private

  def sms_or_email(admin_user)
    if admin_user.sms_gateway.present?
      admin_user.sms_gateway
    else
      admin_user.email
    end
  end

end
