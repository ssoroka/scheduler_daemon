require 'spec_helper'
require 'scheduler_daemon/command_line_args_to_hash'

describe CommandLineArgsToHash do
  it 'should process arguments' do
    h = CommandLineArgsToHash.parse('--hello')
    h['hello'].should == true
  end
  
  it 'should change key names with - to _' do
    h = CommandLineArgsToHash.parse(['--hi-there'])
    h['hi_there'].should == true
  end
  
  it 'should play nice with array args' do
    h = CommandLineArgsToHash.parse(['--only=one,two,three'], :array_args => 'only')
    h['only'].should == %w(one two three)
  end
  
  it 'should handle multiple args ok' do
    h = CommandLineArgsToHash.parse(['--one', '--two=three'])
    h['one'].should == true
    h['two'].should == 'three'
  end
  
end