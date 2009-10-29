require File.dirname(__FILE__) + '/spec_helper'
require 'scheduler'

describe Scheduler::Base do
  before(:each) do
    command_line_args = ['--do-nothing']
    @scheduler = Scheduler::Base.new(*command_line_args)
    @scheduler.stub!(:log)
  end

  it "should load tasks without errors"
  
  describe 'decide_what_to_run' do
    it "should support --only" do
      @scheduler.decide_what_to_run(%w(--only=alphabets))
      @scheduler.instance_variable_get("@load_only").should == ['alphabets']
    end

    it "should support --except" do
      @scheduler.decide_what_to_run(%w(--except=balloons,monkeys))
      @scheduler.instance_variable_get("@load_except").should == ['balloons', 'monkeys']
    end
  end
  
  it "should decide which tasks to run"
  
  it "should set up exception handling"
  
  it "should add each task to the scheduler"
end