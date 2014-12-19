source 'https://rubygems.org'
# ruby '2.0.0'

gem 'rails', '>= 4.1'

gem 'pg'

# gem 'rack-timeout'
gem 'unicorn'

gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'sass'
gem 'sass-rails'

gem 'sprockets'

gem 'foundation-rails'
gem 'jquery-ui-rails'
gem 'kaminari'

gem 'devise'
gem 'omniauth-facebook'
gem 'simple_form'
gem 'activeadmin', github: 'activeadmin'

gem 'money-rails'
gem 'nokogiri'
# http://stackoverflow.com/questions/3606190/rmagick-warning-while-running-server
gem 'rmagick', require: false

gem 'figaro'
gem 'carrierwave-aws'

gem 'friendly_id', require: 'friendly_id'

group :development, :test do
	gem 'pry-rails'
  gem 'annotate'
  gem 'ruby-debug-ide' #for Rubymine
  gem 'debase'         #for Rubymine
  gem 'simplecov'      #test coverage reports
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rack-livereload'
  gem 'guard-livereload', require: false
  gem 'rb-fsevent', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rspec-collection_matchers'
  gem 'guard'
  gem 'guard-rspec'
  gem 'webmock'
  gem 'vcr'
end

group :production, :staging do
  gem 'rails_12factor'
end


