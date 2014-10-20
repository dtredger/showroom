# ActionMailer::Base.smtp_settings = {
#   port:           '587',
#   address:        'smtp.mandrillapp.com',
#   user_name:      ENV['MANDRILL_USERNAME'],
#   password:       ENV['MANDRILL_APIKEY'],
#   domain:         'heroku.com',
#   authentication: :plain,
# }
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
	address: "smtp.gmail.com",
	port: 587,
	domain: "gmail.com",
	user_name: "ENV['GMAIL_ADDR']",
	password: ENV['GMAIL_PWD'],
	authentication: "plain",
	enable_starttls_auto: true
}