class AdminMailer < ApplicationMailer

  def jobs_notifier(admin_users, message)
    @message = message
    mail to: admin_users.email, subject: "Background Jobs Update"
  end

  def error_notifier(admin_users, error)
    @error = error
    mail to: sms_or_email(admin_users), subject: "Showspace error"
  end


  private

  def sms_or_email(admin_users)
    if admin_users.is_a? Array
      destinations = []
      admin_users.each do |admin|
        if admin.sms_gateway.present?
          destinations << admin.sms_gateway
        else
          destinations << admin.email
        end
      end
      destinations
    else
      if admin_users.sms_gateway.present?
        admin_users.sms_gateway
      else
        admin_users.email
      end
    end
  end

end
