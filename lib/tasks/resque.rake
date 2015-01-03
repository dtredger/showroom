require 'resque/tasks'

## loads the entire env; consider something less
#task 'resque:setup' => :environment


namespace :resque do
  task :setup => :environment do
    require 'resque'
    puts "resque:setup executed!"
  end
end