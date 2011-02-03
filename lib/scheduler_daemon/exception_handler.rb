# override this in your app to do something meaningful,
# like post to campfire or hoptoad.
# 
# Example campfire code below, using 'tinder' gem:
module Scheduler
  class ExceptionHandler
    # @@campfire_subdomain = ''
    # @@campfire_username = ''
    # @@campfire_password = ''
    # @@campfire_room_name = ''
    # @@campfire_room = nil

    def self.handle_exception(exception, job, message)
      # If your team all hangs out in Campfire, you might want to try
      # something like Tinder here to write these messages out to campfire,
      # Such as:
      # 
      # if Rails.env.production? || Rails.env.staging?
      #   msg = "#{message}, see log for backtrace"
      # 
      #   unless @@campfire_room
      #     campfire = Tinder::Campfire.new(@@campfire_subdomain, :ssl => true)
      #     campfire.login(@@campfire_username, @@campfire_password)
      #     @@campfire_room = campfire.find_room_by_name(@@campfire_room_name)
      #   end
      #   @@campfire_room.speak(msg)
      # end
    end
  end
end
