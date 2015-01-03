ActionMailer::Base.smtp_settings = {
  port:           '587',
  address:        'smtp.mandrillapp.com',
  user_name:      ENV['MANDRILL_USERNAME'],
  password:       ENV['MANDRILL_APIKEY'],
  domain:         'heroku.com',
  authentication: :plain,
}
# Currently Develop and Test are set to delivery_method :test
# Only production has ActionMailer::Base.delivery_method = :smtp

