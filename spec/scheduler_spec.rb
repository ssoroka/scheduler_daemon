require File.dirname(__FILE__) + '/spec_helper'
require 'scheduler_daemon/base'

describe Scheduler::Base do
  before(:each) do
    @scheduler = Scheduler::Base.new(:skip_init => true, :silent => true)
    @scheduler.stub!(:log)
  end

  describe 'decide_what_to_run' do
    it "should support --only" do
      @scheduler = Scheduler::Base.new({:skip_init => true, :silent => true}, ['--only=alphabets'])
      @scheduler.options['only'].should == ['alphabets']
    end

    it "should support --except" do
      @scheduler = Scheduler::Base.new({:skip_init => true, :silent => true}, ['--except=balloons,monkeys'])
      @scheduler.options['except'].should == ['balloons', 'monkeys']
    end
  end
end