# hijack puts to log with a timestamp, since any output is going to be logged anyway.
module Kernel
  def puts_with_timestamp(*args)
    time = Time.respond_to?(:zone) ? Time.zone.now.to_s : Time.now.to_s
    puts_without_timestamp(%([#{time}] #{args.join("\n")}))
  end
  alias_method_chain :puts, :timestamp
end
