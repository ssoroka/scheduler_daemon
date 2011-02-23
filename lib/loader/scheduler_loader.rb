#!/usr/bin/env ruby
# This file loads the rails environment and starts the scheduler.
# do not use it directly unless you don't intend for the scheduler to run as a daemon.
require 'scheduler_daemon/command_line_args_to_hash'
args = CommandLineArgsToHash.parse(ARGV)
daemons_lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Dir.chdir(args[:dir])

require File.join(daemons_lib_dir, 'scheduler_daemon', 'base')

Scheduler::Base.new(args)
