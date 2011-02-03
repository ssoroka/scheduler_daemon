class SchedulerTaskGenerator < Rails::Generators::NamedBase
  check_class_collision :suffix => 'Task'
  
  def create_task
    template File.join(source_dir, 'example_task.rb'), "scheduled_tasks/#{file_name}_task.rb"
    readme(File.join(template_dir, 'README'))
  end
  
  private
    def source_dir
      File.join(template_dir, 'scheduled_tasks')
    end
    
    def template_dir
      File.join(File.dirname(__FILE__), 'templates')
    end
end
