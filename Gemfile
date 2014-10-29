source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 4.1.0'

gem 'pg'

gem 'rack-timeout'
gem 'unicorn'

gem 'activejob'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'sass'

gem 'foundation-rails'
gem 'jquery-ui-rails'
gem 'will_paginate', '~> 3.0'

gem 'devise', '3.2.4'
gem 'omniauth-facebook'
gem 'simple_form'

gem 'money-rails'
gem 'nokogiri'
# http://stackoverflow.com/questions/3606190/rmagick-warning-while-running-server
gem 'rmagick', :require => false

gem 'figaro'
gem 'carrierwave-aws'

group :development, :test do
	gem 'pry-rails'
  gem 'annotate'
  gem 'ruby-debug-ide' #for Rubymine
  gem 'debase'         #for Rubymine
  gem 'simplecov'      #test coverage reports
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rspec-collection_matchers'
  gem 'guard'
  gem 'guard-rspec'
end

group :production, :staging do
  gem 'rails_12factor'
end


