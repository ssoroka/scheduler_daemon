# copy this spec to your project after installing the plugin if you want to run the specs.
# suggested file name for this file: spec/scheduler_daemon/scheduled_tasks/session_cleaner_task_spec.rb

require File.dirname(__FILE__) + '/../../spec_helper'
require 'daemons/lib/scheduler_task'
require 'daemons/lib/scheduled_tasks/remove_old_sessions_task'

describe RemoveOldSessionsTask do
  before(:each) do
    @task = RemoveOldSessionsTask.new
    @task.stub!(:puts)
  end

  it "should remove old sessions" do
    # this test only matters if we're using AR's session store.
    if ActionController::Base.session_store == ActiveRecord::SessionStore

      # insert old session
      ActiveRecord::Base.connection.execute(%(delete from #{@task.session_table_name} where session_id = 'abc123'))
      ActiveRecord::Base.connection.execute(%(insert into #{@task.session_table_name} (session_id, updated_at) values ('abc123', '#{2.years.ago.to_s(:db)}')))

      get_session_count = lambda {
        ActiveRecord::Base.connection.select_one(%(select count(*) as count from #{@task.session_table_name}))['count'].to_i
      }

      lambda {
        @task.run
      }.should change(get_session_count, :call).by_at_most(-1)
    end
  end
end