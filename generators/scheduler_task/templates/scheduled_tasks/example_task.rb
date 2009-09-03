class <%= class_name %>Task < SchedulerTask
  every '10s'
  
  def run
    # Your code here, eg: User.send_due_invoices!
    puts "I've sent invoices!"
  end
end