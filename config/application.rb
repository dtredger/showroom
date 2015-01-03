require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Showspace
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.i18n.enforce_available_locales = true

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: true
      g.fixture_replacement :factory_girl,
        dir: "spec/factories"
      g.integration_tool :rspec, fixture: true, views: true
    end

    # Do not log passwords
    config.filter_parameters += [:password, :password_confirmation]
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    # http://blog.seancarpenter.net/2012/11/05/page-specific-javascript-with-the-asset-pipeline/
    config.assets.precompile += %w( *-bundle.js )
    config.assets.precompile += %w( *-bundle.css )

    # https://devcenter.heroku.com/articles/rails-4-asset-pipeline
    # this is set in each environment directly (dev/test=true, prod=false)
    # config.serve_static_files = true

    # squelch warning about errors raised within `after_rollback`/`after_commit` callbacks
    config.active_record.raise_in_transactional_callbacks = true
  end
end
