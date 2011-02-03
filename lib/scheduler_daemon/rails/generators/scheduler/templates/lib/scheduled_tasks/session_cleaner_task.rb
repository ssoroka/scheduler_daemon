class SessionCleanerTask < Scheduler::SchedulerTask
  environments :all
  
  every '1d', :first_at => Chronic.parse('next 2 am')
  
  def run
    remove_old_sessions
  end
  
  def remove_old_sessions
    log "running the session cleaner"
    if ActionController::Base.session_store == session_store_class
      ActiveRecord::Base.connection.execute("DELETE FROM #{session_table_name} WHERE updated_at < '#{7.days.ago.to_s(:db)}'")
      log "old sessions are gone!"
    else
      log "sessions are not stored in the database; nothing to do."
    end
  end

  def session_store_class
    return ActiveRecord::SessionStore if defined?(ActiveRecord::SessionStore)
    # pre rails 2.3 support...
    return CGI::Session::ActiveRecordStore if defined?(CGI::Session::ActiveRecordStore)
  end

  def session_table_name
    ActiveRecord::Base.pluralize_table_names ? :sessions : :session
  end
end
