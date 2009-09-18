require File.dirname(__FILE__) + '/../spec_helper'

describe Scheduler::Base do
  it "should load tasks without errors"
  it "should decide which tasks to run"
  it "should support --only"
  it "should support --except"
  it "should set up exception handling"
  it "should add each task to the scheduler"
end