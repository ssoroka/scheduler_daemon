require 'rubygems'
spec_runner = nil
begin
  require 'rspec'
  spec_runner = RSpec
rescue
  require 'spec'
  spec_runner = Spec::Runner
end
require 'chronic'
require 'active_support'

RAILS_ENV = 'test' unless defined?(RAILS_ENV) && RAILS_ENV == 'test'

spec_runner.configure do |config|
end