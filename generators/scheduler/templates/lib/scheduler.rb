require 'eventmachine'
require 'rufus/scheduler'
require File.join(File.dirname(__FILE__), 'scheduler', 'hijack_puts')
require File.join(File.dirname(__FILE__), 'scheduler', 'scheduler_task')
require File.join(File.dirname(__FILE__), 'scheduler', 'exception_handler')

module Scheduler
  class Base
    attr_reader :load_only, :load_except, :tasks

    def initialize(*command_line_args)
      @load_only = []
      @load_except = []
      @tasks = []
      @rufus_scheduler = nil

      decide_what_to_run(command_line_args)
      load_tasks
      run_scheduler
    end

    def run_scheduler
      puts "Starting Scheduler in #{RAILS_ENV}"

      EventMachine::run {
        @rufus_scheduler = Rufus::Scheduler::EmScheduler.start_new

        def @rufus_scheduler.handle_exception(job, exception)
          msg = "[#{RAILS_ENV}] scheduler job #{job.job_id} (#{job.tags * ' '}) caught exception #{exception.inspect}"
          puts msg
          puts exception.backtrace.join("\n")
          Scheduler::ExceptionHandler.handle_exception(exception, job, message)
        end

        # This is where the magic happens.  tasks in scheduled_tasks/*.rb are loaded up.
        tasks.each do |task|
          if task.should_run_in_current_environment?
            task.add_to(@rufus_scheduler)
          else
            puts "#{task} configured not to run in #{RAILS_ENV} environment; skipping."
          end
        end
      }
    end

    def load_tasks
      tasks_to_run.each{|f|
        begin
          unless load_only.any? && load_only.all?{|m| f !~ Regexp.new(Regexp.escape(m)) }
            require f
            filename = f.split('/').last.split('.').first
            puts "Loading task #{filename}..."
            tasks << filename.camelcase.constantize # path/newsfeed_task.rb => NewsfeedTask
          end
        rescue Exception => e
          msg = "Error loading task #{filename}: #{e.class.name}: #{e.message}"
          puts msg
          puts e.backtrace.join("\n")
          Railsbot.say "#{msg}, see log for backtrace" if Rails.env.production? || Rails.env.staging?
        end
      }
    end

    def tasks_to_run
      task_files = Dir[File.join(File.dirname(__FILE__), %w(scheduled_tasks *.rb))]

      if load_only.any?
        task_files.reject!{|f| load_only.all?{|m| f !~ Regexp.new(Regexp.escape(m))}}
      end

      if load_except.any?
        task_files.reject!{|f| load_except.any?{|m| f =~ Regexp.new(Regexp.escape(m))}}
      end
      task_files
    end

    # takes input from command line to later modify list of tasks to run
    def decide_what_to_run(command_line_args)
      # allow ruby daemons/bin/task_runner.rb run -- --only=toadcamp,newsfeed
      if only_arg = command_line_args.detect{|arg| arg =~ /^--only/}
        @load_only = only_arg.split('=').last.split(',')
      end

      # allow ruby daemons/bin/task_runner.rb run -- --except=toadcamp
      if except_arg = command_line_args.detect{|arg| arg =~ /^--except/}
        @load_except = except_arg.split('=').last.split(',')
      end
    end
  end
end