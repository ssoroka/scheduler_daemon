Gem::Specification.new do |s|
  s.name = "scheduler_daemon"
  s.version = "1.1.5"
  s.description = "a Rails 2.3, Rails 3, and Ruby compatible scheduler daemon.  Replaces cron/rake pattern of periodically running rake tasks to perform maintenance tasks, only loading the environment ONCE."
  s.summary = "Rails 3 compatible scheduler daemon.  Replaces cron/rake pattern of periodically running rake tasks to perform maintenance tasks in Rails apps. Scheduler Daemon is made specifically for your Rails app, and only loads the environment once, no matter how many tasks run.  What's so great about it?  Well, I'm glad you asked!  - Only loads your Rails environment once on daemon start, not every time a task is run - Allows you to easily deploy the scheduled tasks with your Rails app instead of depending on an administrator to update crontab - It doesn't use rake or cron! - Gets you up and running with your own daemon in under 2 minutes"
  s.homepage = "http://github.com/ssoroka/scheduler_daemon"

  s.authors = ["Steven Soroka"]
  s.email = "ssoroka78@gmail.com"

  s.date = Time.now.strftime("%Y-%m-%d")
  s.files = `git ls-files -z`.split("\x0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
    s.add_dependency("activesupport", ">= 0")
    s.add_dependency("eventmachine", ">= 0.12.8")
    s.add_dependency("daemons", ">= 1.0.10")
    s.add_dependency("rufus-scheduler", "~> 2.0.24")
    s.add_dependency("chronic", ">= 0.2.0")
    s.add_development_dependency("rspec", "~> 2.13.0")
    s.add_development_dependency("rake")
  else
    s.add_dependency("activesupport", [">= 0"])
    s.add_dependency("eventmachine", [">= 0.12.8"])
    s.add_dependency("daemons", [">= 1.0.10"])
    s.add_dependency("rufus-scheduler", ["~> 2.0.24"])
    s.add_dependency("chronic", [">= 0.2.0"])
    s.add_dependency("rspec", ["~> 2.13.0"])
    s.add_dependency("rake", [">= 0"])
  end
end

