module Scheduler
  class SchedulerTask
    class <<self
      def add_to(schedule)
        %w(every in at cron).each{|time|
          if args = self.instance_variable_get("@#{time}")
            # add a default tag to the arguments so we know which task was running
            options = args.extract_options!
            options.merge!(:tags => [name])
            # args = ['5s'] if Rails.env.development? # just for testing. :)
            args << options

            schedule.send(time, *args) do
              begin
                new.run
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

      def should_run_in_current_environment?
        @environments.nil? || @environments == [:all] || @environments.include?(RAILS_ENV.to_sym)
      end
    end

    # override me to do stuff
    def run
      nil
    end
  end
end
SchedulerTask = Scheduler::SchedulerTask # alias this for backwards compatability