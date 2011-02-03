class SchedulerGenerator < Rails::Generator::Base
  def banner
    "Usage: #{$0} #{spec.name}"
  end

  def manifest
    record do |m|
      m.directory File.join('lib', 'scheduled_tasks')

      m.template 'lib/scheduled_tasks/session_cleaner_task.rb',
        'lib/scheduled_tasks/session_cleaner_task.rb'
      
      m.readme('README')
    end
  end
end
