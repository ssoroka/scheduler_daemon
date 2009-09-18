class SessionCleanerTask < Scheduler::SchedulerTask
  environments :all
  
  every '1d', :first_at => Chronic.parse('2 am')
  
  def run
    puts "running the session cleaner"
    remove_old_sessions
    puts "old sessions are gone!"
  end
  
  def remove_old_sessions
    if ActionController::Base.session_store == ActiveRecord::SessionStore
      ActiveRecord::Base.connection.execute("DELETE FROM #{session_table_name} WHERE updated_at < '#{7.days.ago.to_s(:db)}'")
    end
  end
  
  def session_table_name
    ActiveRecord::Base.pluralize_table_names ? :sessions : :session
  end
end
