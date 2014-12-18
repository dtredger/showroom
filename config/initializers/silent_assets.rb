# to squelch rails' incessant logging of asset-pipeline, such as:
# Started GET "/assets/application.js?body=1" for 127.0.0.1 at 2014-08-13 13:12:16 -0400

Rails.application.assets.logger = Logger.new('/dev/null')
Rails::Rack::Logger.class_eval do
  def call_with_quiet_assets(env)
    previous_level = Rails.logger.level
    Rails.logger.level = Logger::ERROR if env['PATH_INFO'].index("/assets/") == 0
    call_without_quiet_assets(env).tap do
      Rails.logger.level = previous_level
    end
  end
  alias_method_chain :call, :quiet_assets
end