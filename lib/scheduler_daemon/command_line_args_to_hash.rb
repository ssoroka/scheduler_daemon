begin
  require 'active_support/hash_with_indifferent_access'
rescue LoadError
  begin
    require 'active_support/core_ext/hash'
  rescue LoadError
    puts "can't load activesupport gem not loaded"
    raise $!
  end
end

class CommandLineArgsToHash
  def self.parse(args, options = {})
    new(args, options).parse
  end
  
  def initialize(args, options = {})
    @args = args
    @options = options
  end
  
  def parse
    hash = ::HashWithIndifferentAccess.new
    @args.each{|arg|
      k, v = read_argument(arg)
      hash[k] = v
    }
    hash
  end
  
  def read_argument(arg)
    k, v = arg.sub(/^\-\-/, '').split('=')
    k = k.gsub(/-/, '_') # replace - to _ so that --skip-init becomes options[:skip_init]
    v = true if v.nil? # default passed in args to true.
    v = format_value(k, v)
    [k, v]
  end
  
  def format_value(k, v)
    if @options[:array_args] && @options[:array_args].include?(k)
      v = v.split(/,\s*/) if v.respond_to?(:split)
    end
    v = false if v == 'false'
    v = true if v == 'true'
    v
  end
end