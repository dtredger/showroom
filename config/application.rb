require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Showspace
  class Application < Rails::Application

    # Do nots log passwords
    config.filter_parameters += [:password, :password_confirmation]    
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    # http://blog.seancarpenter.net/2012/11/05/page-specific-javascript-with-the-asset-pipeline/
    config.assets.precompile += %w( *-bundle.js )
    config.assets.precompile += %w( *-bundle.css )

  end
end
