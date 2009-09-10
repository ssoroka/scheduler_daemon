require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "scheduler daemon" do
  # copy this spec to your project after installing the plugin if you want to run the specs.
  # TODO: improve these specs so they don't depend on a rails project to run
  it "should start up and load configurations without errors" do
    results = `ruby #{Rails.root}/daemons/bin/task_runner.rb run`
    results.should include("Loading task newsfeed_task")
    results.should include("Loading task remove_old_sessions_task")
  end
  
  it "should load --only properly" do
    results = `ruby #{Rails.root}/daemons/bin/task_runner.rb run -- --only=newsfeed`
    results.should include("Loading task newsfeed_task")
    results.should_not include("Loading task remove_old_sessions_task")
  end
  
  it "should load --except properly" do
    results = `ruby #{Rails.root}/daemons/bin/task_runner.rb run -- --except=newsfeed`
    results.should_not include("Loading task newsfeed_task")
    results.should include("Loading task remove_old_sessions_task")
  end
end
