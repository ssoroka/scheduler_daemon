#!/usr/bin/env ruby
# USAGE: 
# 
# ruby scheduler/bin/scheduler_daemon.rb run     -- start the daemon and stay on top
# ruby scheduler/bin/scheduler_daemon.rb start   -- start the daemon and stay on top
# ruby scheduler/bin/scheduler_daemon.rb stop    -- stop the daemon
# ruby scheduler/bin/scheduler_daemon.rb restart -- stop the daemon and restart it afterwards

require 'rubygems'
require 'daemons'

boot_scheduler = File.join(File.dirname(__FILE__), 'boot.rb')
pid_dir = File.expand_path(File.join(File.dirname(__FILE__), %w(.. .. log)))

FileUtils.mkdir_p(pid_dir) unless File.exist?(pid_dir)

app_options = { 
  :dir_mode => :normal,
  :dir => pid_dir,
  :multiple => false,
  :backtrace => true,
  :log_output => true
}

Daemons.run(boot_scheduler, app_options)