require 'eventmachine'
require 'rufus/scheduler'
begin
  require 'active_support/hash_with_indifferent_access'
rescue LoadError
  begin
    require 'active_support/core_ext/hash'
  rescue LoadError
    puts "can't load activesupport gem not loaded"
    raise $!
  end
end

require 'scheduler_daemon/scheduler_task'
require 'scheduler_daemon/exception_handler'
require 'scheduler_daemon/command_line_args_to_hash'

module Scheduler
  class Base
    attr_reader :tasks, :options, :env_name

    # :root_dir is a required option, because the scheduler likely has no idea what the original
    #     root directory was after the process was daemonized (which changes the current directory)
    # :silent
    #     doesn't output anything to STDOUT or logs.
    # :root_dir
    #     root dir of the application.
    # :only
    #     load only tasks in this list
    # :except
    #     load all tasks except ones in this list
    # :env_name
    #     if used without rails, you can manually set something in place of the environment name
    def initialize(opts = {}, command_line_args = [])
      @options = ::HashWithIndifferentAccess.new(opts)
      @options.merge!(CommandLineArgsToHash.parse(command_line_args, :array_args => ['only', 'except']))
      @options['only'] ||= []
      @options['except'] ||= []
      @env_name = @options['env_name'] || 'scheduler'
      @rufus_scheduler = nil
      @tasks = []
      
      log("initialized with settings: #{@options.inspect}")

      if !@options['skip_init']
        load_rails_env
        load_tasks
        run_scheduler
      end
    end
    
    # registers a task class with the scheduler
    def register_task(task)
      
    end
    
    def load_rails_env
      if File.exists?('config/environment.rb') && !@options['skip_rails']
        log("loading rails environment")
        require 'config/environment'
        @env_name = ::Rails.env
      end
    rescue
      log("Error loading rails environment; #{$!.class.name}: #{$!.message}")
      raise $!
    end
    
    # time redefines itself with a faster implementation, since it gets called a lot.
    def time
      if Time.respond_to?(:zone) && Time.zone
        self.class.send(:define_method, :time) { Time.zone.now.to_s }
      else
        self.class.send(:define_method, :time) { Time.now.to_s }
      end
      time
    end
    
    def log(*args)
      return if @options[:silent]
      Kernel::puts(%([#{time}] #{args.join("\n")}))
    end
    alias :puts :log

    def run_scheduler
      if defined?(::Rails)
        log "Starting Scheduler in #{::Rails.env}"
      else
        log "Starting Scheduler"
      end

      $daemon_scheduler = self

      EventMachine::run {
        @rufus_scheduler = Rufus::Scheduler::EmScheduler.start_new

        def @rufus_scheduler.handle_exception(job, exception)
          msg = "[#{env_name}] scheduler job #{job.job_id} (#{job.tags * ' '}) caught exception #{exception.inspect}"
          log msg
          log exception.backtrace.join("\n")
          Scheduler::ExceptionHandler.handle_exception(exception, job, message)
        end

        def @rufus_scheduler.daemon_scheduler
          $daemon_scheduler
        end

        # This is where the magic happens.  tasks in scheduled_tasks/*.rb are loaded up.
        tasks.each do |task|
          if task.should_run_in_current_environment?(env_name)
            task.add_to(@rufus_scheduler)
          else
            log "[#{env_name}] #{task} not configured to run; skipping."
          end
        end
      }
    end

    def load_tasks
      tasks_to_run.each{|f|
        begin
          unless options[:only].any? && options[:only].all?{|m| f !~ Regexp.new(Regexp.escape(m)) }
            require f
            filename = f.split('/').last.split('.').first
            log "Loading task #{filename}..."
            @tasks << filename.camelcase.constantize # "path/newsfeed_task.rb" => NewsfeedTask
          end
        rescue Exception => e
          msg = "Error loading task #{filename}: #{e.class.name}: #{e.message}"
          log msg
          log e.backtrace.join("\n")
          Scheduler::ExceptionHandler.handle_exception(e, nil, msg)
        end
      }
    end

    def tasks_to_run
      task_files = Dir[File.join(%w(scheduled_tasks *.rb))]# + File.join(%w(lib scheduled_tasks *.rb))

      if options[:only].any?
        task_files.reject!{|f| options[:only].all?{|m| f !~ Regexp.new(Regexp.escape(m))}}
      end

      if options[:except].any?
        task_files.reject!{|f| options[:except].any?{|m| f =~ Regexp.new(Regexp.escape(m))}}
      end
      task_files
    end
  end
end