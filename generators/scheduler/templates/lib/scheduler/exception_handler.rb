module Scheduler
  class ExceptionHandler
    # Change me to do something meaningful
    def self.handle_exception(exception, job, message)
      # If your team all hangs out in Campfire, you might want to make a
      # Campfire class that makes use of the tinder gem to write these errors there.
      #
      # eg:
      # Campfire.say "#{msg}, see log for backtrace" if Rails.env.production? || Rails.env.staging?
    end
  end
end
