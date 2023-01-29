require 'spec_helper'
require 'scheduler_daemon/command_line_args_to_hash'

describe CommandLineArgsToHash do
  it 'should process arguments' do
    h = CommandLineArgsToHash.parse(['--hello'])
    expect(h['hello']).to eq true
  end

  it 'should change key names with - to _' do
    h = CommandLineArgsToHash.parse(['--hi-there'])
    expect(h['hi_there']).to eq true
  end

  it 'should play nice with array args' do
    h = CommandLineArgsToHash.parse(['--only=one,two,three'], :array_args => 'only')
    expect(h['only']).to eq %w(one two three)
  end

  it 'should handle multiple args ok' do
    h = CommandLineArgsToHash.parse(['--one', '--two=three'])
    expect(h['one']).to eq true
    expect(h['two']).to eq 'three'
  end

end
