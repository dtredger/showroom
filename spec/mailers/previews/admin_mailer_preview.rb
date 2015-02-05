class AdminMailerPreview < ActionMailer::Preview

  def jobs_notifier
    admin = AdminUser.first
    message = "something finished and it was good"
    AdminMailer.jobs_notifier(admin, message)
  end

  def error_notifier
    admin = AdminUser.first
    error = "some error"
    AdminMailer.error_notifier(admin, error)
  end

end