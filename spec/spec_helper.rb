require 'rubygems'
begin
  require 'rspec'
rescue
  require 'spec'
end
require 'chronic'

RAILS_ENV = 'test'

Spec::Runner.configure do |config|
end