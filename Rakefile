require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "scheduler_daemon"
    gem.summary = %Q{Rails 2.3.2 compatible scheduler daemon.  Replaces cron/rake pattern of periodically running rake tasks 
    to perform maintenance tasks in Rails apps. Scheduler Daemon is made specifically for your Rails app, 
    and only loads the environment once, no matter how many tasks run.

    What's so great about it?  Well, I'm glad you asked!

    - Only loads your Rails environment once on daemon start, not every time a task is run
    - Allows you to easily deploy the scheduled tasks with your Rails app instead of depending on an
      administrator to update crontab
    - It doesn't use rake or cron!
    - Gets you up and running with your own daemon in under 2 minutes
    }
    gem.email = "ssoroka78@gmail.com"
    gem.homepage = "http://github.com/ssoroka/scheduler_daemon"
    gem.authors = ["Steven Soroka"]
    gem.add_dependency('eventmachine', '>= 0.12.8')
    gem.add_dependency('daemons', '>= 1.0.10')
    gem.add_dependency('rufus-scheduler', '>= 2.0.1')
    gem.add_dependency('chronic', '>= 0.2.0')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end


task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "scheduler_daemon #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

