class SchedulerTaskGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory File.join('scheduler', 'lib', 'scheduled_tasks')

      m.template 'scheduled_tasks/example_task.rb', "scheduler/lib/scheduled_tasks/#{file_name}_task.rb", :assigns => { :class_name => class_name }

      m.readme('README')
    end
  end
end
