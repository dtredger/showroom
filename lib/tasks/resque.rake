require 'resque/tasks'
require 'resque/scheduler/tasks'

## loads the entire env; consider something less
#task 'resque:setup' => :environment



namespace :resque do
  task :setup => :environment do
    require 'resque'
    require 'resque-scheduler'
    require 'resque/scheduler'
    puts "resque:setup executed!"

  end
end