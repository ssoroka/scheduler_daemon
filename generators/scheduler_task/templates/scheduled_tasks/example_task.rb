class <%= class_name %>Task < Scheduler::SchedulerTask
  environments :all
  
  every '10s'
  
  def run
    # Your code here, eg: User.send_due_invoices!
    # use puts for writing to log, eg: puts "I've sent invoices!"
  end
end