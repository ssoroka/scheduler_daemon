# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scheduler_daemon}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steven Soroka"]
  s.date = %q{2009-09-10}
  s.email = %q{ssoroka78@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "CHANGES",
     "MIT-LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "generators/scheduler/USAGE",
     "generators/scheduler/scheduler_generator.rb",
     "generators/scheduler/templates/README",
     "generators/scheduler/templates/bin/scheduler_daemon.rb",
     "generators/scheduler/templates/lib/scheduled_tasks/session_cleaner_task.rb",
     "generators/scheduler/templates/lib/scheduler.rb",
     "generators/scheduler/templates/lib/scheduler_task.rb",
     "generators/scheduler_task/scheduler_task_generator.rb",
     "generators/scheduler_task/templates/README",
     "generators/scheduler_task/templates/scheduled_tasks/example_task.rb",
     "init.rb",
     "install.rb",
     "lib/scheduler.rb",
     "scheduler_daemon.gemspec",
     "spec/daemon_spec.rb",
     "spec/spec_helper.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/ssoroka/scheduler_daemon}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Rails 2.3.2 compatible scheduler daemon.  Replaces cron/rake pattern of periodically running rake tasks  to perform maintenance tasks in Rails apps. Scheduler Daemon is made specifically for your Rails app,  and only loads the environment once, no matter how many tasks run.  What's so great about it?  Well, I'm glad you asked!  - Only loads your Rails environment once on daemon start, not every time a task is run - Allows you to easily deploy the scheduled tasks with your Rails app instead of depending on an administrator to update crontab - It doesn't use rake or cron! - Gets you up and running with your own daemon in under 2 minutes}
  s.test_files = [
    "spec/daemon_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0.12.8"])
      s.add_runtime_dependency(%q<daemons>, [">= 1.0.10"])
      s.add_runtime_dependency(%q<rufus-scheduler>, [">= 2.0.1"])
      s.add_runtime_dependency(%q<chronic>, [">= 0.2.0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0.12.8"])
      s.add_dependency(%q<daemons>, [">= 1.0.10"])
      s.add_dependency(%q<rufus-scheduler>, [">= 2.0.1"])
      s.add_dependency(%q<chronic>, [">= 0.2.0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0.12.8"])
    s.add_dependency(%q<daemons>, [">= 1.0.10"])
    s.add_dependency(%q<rufus-scheduler>, [">= 2.0.1"])
    s.add_dependency(%q<chronic>, [">= 0.2.0"])
  end
end
