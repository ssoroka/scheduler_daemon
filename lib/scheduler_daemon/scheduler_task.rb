module Scheduler
  class SchedulerTask
    attr_accessor :daemon_scheduler, :rufus_scheduler
    class <<self
      def add_to(schedule)
        %w(every in at cron).each{|time_cmd|
          if args = self.instance_variable_get("@#{time_cmd}")
            # add a default tag to the arguments so we know which task was running
            options = args.extract_options!
            options.merge!(:tags => [name])
            args << options

            schedule.send(time_cmd, *args) do
              begin
                a_task = new
                a_task.daemon_scheduler = schedule.daemon_scheduler
                a_task.rufus_scheduler = schedule
                a_task.run
              ensure
                # Note: AR's ActiveRecord::Base.connection_pool.with_connection(&block) seems broken;
                # it doesn't release the connection properly.
                ActiveRecord::Base.connection_pool.release_connection
              end
            end
          end
        }
      end

      # run the task every... '5m', etc. see rufus-scheduler docs
      def every(*args)
        @every = args
      end

      # run the task in '30s', etc. see rufus-scheduler docs
      def in(*args)
        @in = args
      end

      # run the task at... Cronic.parse('5 pm'), etc. see rufus-scheduler docs
      def at(*args)
        @at = args
      end

      # run the task cron '* 4 * * *', etc. see rufus-scheduler docs
      def cron(*args)
        @cron = args
      end

      # what environments should this task run in?
      # accepts the usual :development, :production, as well as :all
      #
      # examples:
      #   environments :all
      #   environments :staging, :production
      #   environments :development
      #
      def environments(*args)
        @environments = args.map{|arg| arg.to_sym }
      end

      def should_run_in_current_environment?(env)
        @environments.nil? || @environments == [:all] || @environments.include?(env.to_sym)
      end
    end

    # override me to do stuff
    def run
      nil
    end
    
    def log(*args)
      daemon_scheduler.log(*args)
    end
    alias :puts :log
  end
end
# alias this for backwards compatability
# SchedulerTask = Scheduler::SchedulerTask unless defined?(::SchedulerTask)
