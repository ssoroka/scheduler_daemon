class SchedulerGenerator < Rails::Generator::Base
  def banner
    "Usage: #{$0} #{spec.name}"
  end

  def manifest
    record do |m|
      m.directory File.join('scheduler', 'bin')
      m.directory File.join('scheduler', 'lib', 'scheduled_tasks')
      m.directory File.join('scheduler', 'log')

      m.template 'bin/scheduler_daemon.rb', 'scheduler/bin/scheduler_daemon.rb'
      m.template 'lib/scheduler.rb', 'scheduler/lib/scheduler.rb'
      m.template 'lib/scheduled_tasks/session_cleaner_task.rb', 'scheduler/lib/scheduled_tasks/session_cleaner_task.rb'
      
      m.readme('README')
    end
  end
end
