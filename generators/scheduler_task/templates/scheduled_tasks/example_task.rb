class <%= class_name %>Task < Scheduler::SchedulerTask
  environments :all
  
  every '10s'
  
  def run
    # Your code here, eg: User.send_due_invoices!
    # use log() for writing to scheduler daemon log, eg: log("I've sent invoices!")
  end
end