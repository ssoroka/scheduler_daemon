#!/usr/bin/env ruby
# This file loads the rails environment and starts the scheduler.
# do not use it directly unless you don't intend for the scheduler to run as a daemon.
require File.join(File.dirname(__FILE__), 'find_rails_root')

rails_root = FindRailsRoot.locate
daemons_lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))

# puts %(Changing to directory "#{rails_root}" and loading environment...)
Dir.chdir(rails_root)

require 'config/environment'
require File.join(daemons_lib_dir, 'scheduler')

Scheduler::Base.new(rails_root, ARGV)
