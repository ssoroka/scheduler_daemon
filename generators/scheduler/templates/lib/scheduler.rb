# load the environment, just once. yay!
rails_root = File.expand_path(File.join(File.dirname(__FILE__), %w(.. ..)))

Dir.chdir(rails_root) do
  require File.join(rails_root, %w(config environment))
  puts "Loaded #{Rails.env} environment"
end

# allow ruby daemons/bin/task_runner.rb run -- --only=toadcamp,newsfeed
load_only = ARGV.detect{|arg| arg =~ /^--only/}.split('=').last.split(',')

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
    unless load_only.any? && load_only.all?{|m| f !~ Regexp.new(Regexp.escape(m)) }
      require f
      filename = f.split('/').last.split('.').first
      puts "Loading task #{filename}..."
      tasks << filename.camelcase.constantize # path/newsfeed_task.rb => NewsfeedTask
    end
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
    puts "[#{Rails.env}] scheduler job #{job.job_id} caught exception #{exception.inspect}"
    # If your team all hangs out in Campfire, you might want to try
    # something like Tinder here to write these messages out to campfire.
  end
}
