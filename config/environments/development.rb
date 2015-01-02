Showspace::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # config.cache_store = :null_store

  # Raise exception if there is sending error
  config.action_mailer.raise_delivery_errors = true

  # http://brewhouse.io/blog/2013/12/17/whats-new-in-rails-4-1.html
  config.action_mailer.preview_path = "spec/mailers/previews/"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = { host: 'localhost.com:3000' }

  # for serving images from local
  config.serve_static_files = true

  # Automatically inject JavaScript needed for LiveReload
 config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload)

  # queue adapter (defaults to inline)
  # config.active_job.queue_adapter = :resque
end


# ------------------------------  OMNIAUTH CONFIG ------------------------------------
# instantly redirect to the callback for omniauth
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
      urls: {:Facebook => 'http://www.facebook.com/jbloggs'},
      location: 'Palo Alto, California',
      verified: true
    },
    credentials: {
      token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
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
        location: {id: '123456789', name: 'Palo Alto, California'},
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