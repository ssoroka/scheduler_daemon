class SchedulerGenerator < Rails::Generator::Base
  def banner
    "Usage: #{$0} #{spec.name}"
  end

  def manifest
    record do |m|
      m.directory File.join('scheduler', 'bin')
      m.directory File.join('scheduler', 'lib', 'scheduled_tasks')
      m.directory File.join('scheduler', 'lib', 'scheduler')

      m.template 'bin/scheduler_daemon.rb', 'scheduler/bin/scheduler_daemon.rb'
      m.template 'bin/boot.rb',             'scheduler/bin/boot.rb'
      
      m.template 'lib/scheduler.rb',                   'scheduler/lib/scheduler.rb'
      m.template 'lib/scheduler/scheduler_task.rb',    'scheduler/lib/scheduler/scheduler_task.rb'
      m.template 'lib/scheduler/hijack_puts.rb',       'scheduler/lib/scheduler/hijack_puts.rb'
      m.template 'lib/scheduler/exception_handler.rb', 'scheduler/lib/scheduler/exception_handler.rb'
      
      m.template 'lib/scheduled_tasks/session_cleaner_task.rb', 'scheduler/lib/scheduled_tasks/session_cleaner_task.rb'
      
      m.readme('README')
    end
  end
end
