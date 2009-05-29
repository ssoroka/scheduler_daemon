module <%= class_name %>Task
  class <<self
    def add_to(scheduler)
      # see rufus-scheduler documentation for more information on what methods scheduler can handle
      scheduler.every "10s" do
        # Your code here, eg: User.send_due_invoices!
        puts "I'm running every 10 seconds! #{Time.now.to_s(:db)}" # delete me, really. :D
        
        # this is required to keep the tasks from eating all the free connections:
        ActiveRecord::Base.connection_pool.release_connection
      end
    end
  end
end