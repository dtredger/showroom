require 'redis'
require 'resque'

require 'resque-scheduler'
require 'resque/scheduler/server'

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(host: uri.host,
                         port: uri.port,
                         password: uri.password,
                         thread_safe: true)


# Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }

Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))




Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == ENV["RESQUE_PASS"] && AdminUser.all.map(&:email).include?(user)
end


