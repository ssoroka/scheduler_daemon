# load the environment, just once. yay!
rails_root = File.expand_path(File.join(File.dirname(__FILE__), %w(.. ..)))
daemons_lib_dir = File.expand_path(File.join(File.dirname(__FILE__), %w(.. lib)))

Dir.chdir(rails_root)

require 'config/environment'
require File.join(daemons_lib_dir, 'scheduler')

Scheduler::Base.new(ARGV)
