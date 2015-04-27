class AdminMailer < ApplicationMailer

  def jobs_notifier(admin_users, message)
    @message = message
    mail from: "Showspace",
         to: all_emails(admin_users),
         subject: "Background Jobs Update"
  end

  def error_notifier(admin_users, error)
    @error = error
    mail from: "Showspace",
         to: sms_or_email(admin_users)
  end


  private

  def all_emails(admin_users)
    if admin_users.respond_to? :each
      admin_users.map(&:email)
    else
      admin_users.email
    end
  end

  def sms_or_email(admin_users)
    if admin_users.respond_to? :each
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
