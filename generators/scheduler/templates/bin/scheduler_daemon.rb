#!/usr/bin/env ruby
# USAGE: 
# 
# ruby scheduler/bin/scheduler_daemon.rb run     -- start the daemon and stay on top
# ruby scheduler/bin/scheduler_daemon.rb start   -- start the daemon and stay on top
# ruby scheduler/bin/scheduler_daemon.rb stop    -- stop the daemon
# ruby scheduler/bin/scheduler_daemon.rb restart -- stop the daemon and restart it afterwards

require 'rubygems'
require 'daemons'

scheduler = File.join(File.dirname(__FILE__), %w(.. lib scheduler.rb))

pid_dir = File.expand_path(File.join(File.dirname(__FILE__), %w(.. log)))

app_options = { 
  :dir_mode => :normal,
  :dir => pid_dir,
  :multiple => false,
  :backtrace => true,
  :log_output => true
}

Daemons.run(scheduler, app_options)