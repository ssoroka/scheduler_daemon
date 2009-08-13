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
  end

  # override me to do stuff
  def run
    nil
  end
end