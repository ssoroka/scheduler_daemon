module Scheduler
  module Rails
    class Railtie < ::Rails::Railtie
      generators do
        require 'scheduler_daemon/rails/generators/scheduler_task/scheduler_task_generator'
      end
    end
  end
end