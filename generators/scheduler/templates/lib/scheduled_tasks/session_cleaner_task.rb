class RemoveOldSessionsTask
  DELETE_RECORDS_OLDER_THAN = lambda { 7.days.ago }

  class << self
    def add_to(scheduler)
      scheduler.every "1d", :first_at => Chronic.parse("2 am") do
        puts "running the session cleaner"
        remove_old_sessions
        puts "old sessions are gone!"
        ActiveRecord::Base.connection_pool.release_connection
      end
    end

    def remove_old_sessions
      case ActionController::Base.session_store
      when ActiveRecord::SessionStore
        session_table_name = ActiveRecord::Base.pluralize_table_names ? :sessions : :session
        ActiveRecord::Base.connection.execute(
          "DELETE FROM #{session_table_name} WHERE updated_at < '#{DELETE_RECORDS_OLDER_THAN.call.to_s(:db)}'"
        )
      when 
      end
    end
  end
end
