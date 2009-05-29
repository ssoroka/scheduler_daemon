# load the environment, just once. yay!
rails_root = File.expand_path(File.join(File.dirname(__FILE__), %w(.. ..)))

Dir.chdir(rails_root) do
  require File.join(rails_root, %w(config environment))
  puts "Loaded #{Rails.env} environment"
end

require 'eventmachine'
require 'rufus/scheduler'

# hijack puts() to include a timestamp
def puts(*args)
  printf("[#{Time.zone.now.to_s}] ")
  super(*args)
end

# load all custom tasks
tasks = []
Dir[File.join(File.dirname(__FILE__), %w(scheduled_tasks *.rb))].each{|f|
  begin
    require f
    filename = f.split('/').last.split('.').first
    puts "Loading task #{filename}..."
    tasks << filename.camelcase.constantize # path/newsfeed_task.rb => NewsfeedTask
  rescue
  end
}

puts "Starting Scheduler at #{Time.now.to_s(:date_with_time)}"

# tasks need to call ActiveRecord::Base.connection_pool.release_connection after running to
# release the connection back to the connection pool, Rails wont handle it for us here.
# 
# Note: AR's ActiveRecord::Base.connection_pool.with_connection(&block) seems broken in
# that respect; it doesn't release the connection properly.
EventMachine::run {
  scheduler = Rufus::Scheduler::EmScheduler.start_new

  # This is where the magic happens.  tasks in scheduled_tasks/*.rb are loaded up.
  tasks.each do |task|
    task.add_to scheduler
  end

  def scheduler.handle_exception(job, exception)
    puts "job #{job.job_id} caught exception '#{exception}'"
  end
}

# # other examples:
# scheduler.cron '0 22 * * 1-5' do
#   # every day of the week at 00:22
#   puts 'activate security system'
# end
# 
# scheduler.every '2d', :timeout => '40m' do
#   begin
#     run_backlog_cleaning()
#   rescue Rufus::Scheduler::TimeOutError => toe
#     # timeout occurred
#   end
# end