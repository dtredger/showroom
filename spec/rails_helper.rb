# require 'simplecov'
#
# SimpleCov.coverage_dir 'spec/coverage'
# SimpleCov.start do
#   add_group 'Models', 'app/models'
#   add_group 'Controllers', 'app/controllers'
#
#   add_filter 'spec'
#   add_filter '/bin/'
#   add_filter '/config/'
#   add_filter '/db/'
#   add_filter '/spec/'
#   add_filter 'config.ru'
#   add_filter 'Gemfile'
#   add_filter 'Guardfile'
# end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'vcr'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.

# -- commented out because I require ControllerMacros specifically, only for controllers below --
# -- not commenting out causes circular dependency? --
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }


# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If you do not include FactoryGirl::Syntax::Methods in your test suite, then
  # all factory_girl methods will need to be prefaced with FactoryGirl.
  config.include FactoryGirl::Syntax::Methods

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # include Devise in specs
  # # https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-%28and-RSpec%29
  config.include Devise::TestHelpers, type: :controller

end

# ---------------------------------  VCR CONFIG --------------------------------------

VCR.configure do |c|
  c.cassette_library_dir = 'spec/factories/vcr_cassettes'
  c.hook_into :webmock
end


# ------------------------------  OMNIAUTH CONFIG ------------------------------------

# instantly redirect to the callback for e
OmniAuth.configure do |config|
  config.test_mode = true
  config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '1234567',
      info: {
          nickname: 'jbloggs',
          email: 'joe@bloggs.com',
          name: 'Joe Bloggs',
          first_name: 'Joe',
          last_name: 'Bloggs',
          image: 'http://graph.facebook.com/1234567/picture?type=square',
          urls: {Facebook: 'http://www.facebook.com/jbloggs'},
          location: 'Palo Alto, California',
          verified: true
      },
      credentials: {
          token: 'TOKEN_OAUTH_2', # OAuth 2.0 access_token, which you may wish to store
          expires_at: 1321747205, # when the access token expires (it always will)
          expires: true # this will always be true
      },
      extra: {
          raw_info: {
              id: '1234567',
              name: 'Joe Bloggs',
              first_name: 'Joe',
              last_name: 'Bloggs',
              link: 'http://www.facebook.com/jbloggs',
              username: 'jbloggs',
              location: {
                  id: '123456789',
                  name: 'Palo Alto, California'
              },
              gender: 'male',
              email: 'joe@bloggs.com',
              timezone: -8,
              locale: 'en_US',
              verified: true,
              updated_time: '2011-11-11T06:21:03+0000'
          }
      }
  })
  config.add_mock(:twitter, {:uid => '12345'})
end