# load the environment, just once. yay!
rails_root = File.expand_path(File.join(File.dirname(__FILE__), %w(.. ..)))

Dir.chdir(rails_root) do
  require File.join(rails_root, %w(config environment))
  puts "Loaded #{Rails.env} environment"
end

# allow ruby daemons/bin/task_runner.rb run -- --only=toadcamp,newsfeed
load_only = []
if only_arg = ARGV.detect{|arg| arg =~ /^--only/}
  load_only = only_arg.split('=').last.split(',')
end

# allow ruby daemons/bin/task_runner.rb run -- --except=toadcamp
load_except = []
if except_arg = ARGV.detect{|arg| arg =~ /^--except/}
  load_except = except_arg.split('=').last.split(',')
end

require 'eventmachine'
require 'rufus/scheduler'
require 'chronic'
require File.join(File.dirname(__FILE__), 'scheduler_task')

# hijack puts() to include a timestamp
def puts(*args)
  printf("[#{Time.zone.now.to_s}] ")
  super(*args)
end

# select which tasks to run
tasks = []
task_files = Dir[File.join(File.dirname(__FILE__), %w(scheduled_tasks *.rb))]
if load_only.any?
  task_files.reject!{|f| load_only.all?{|m| f !~ Regexp.new(Regexp.escape(m))}}
end
if load_except.any?
  task_files.reject!{|f| load_except.any?{|m| f =~ Regexp.new(Regexp.escape(m))}}
end

# load all custom tasks
task_files.each{|f|
  begin
    unless load_only.any? && load_only.all?{|m| f !~ Regexp.new(Regexp.escape(m)) }
      file_name_without_suffix = f.split('/').last.split('.').first
      require f
      task_class = file_name_without_suffix.camelize.constantize
      puts "Loading task #{task_class}..."
      tasks << task_class # path/newsfeed_task.rb => NewsfeedTask
    end
  rescue Exception => e
    msg = "Error loading task #{file_name_without_suffix}: #{e.class.name}: #{e.message}"
    puts msg
    # Might want to make this only in "verbose mode" - hard to see message above
    puts e.backtrace.join("\n")
    # Might want to create a class to talk to your team and do something like.. 
    # Campfire.say "#{msg}, see log for backtrace" if Rails.env.production? || Rails.env.staging?
  end
}

exit if Rails.env.test? # just skip this and quit in test mode, otherwise I pretty much can't test this.

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
    msg = "[#{Rails.env}] scheduler job #{job.job_id} (#{job.tags * ' '}) caught exception #{exception.inspect}"
    puts msg
    puts exception.backtrace.join("\n")
    # If your team all hangs out in Campfire, you might want to try
    # something like Tinder here to write these messages out to campfire.
    # Campfire.say "#{msg}, see log for backtrace" if Rails.env.production? || Rails.env.staging?
  end
}
