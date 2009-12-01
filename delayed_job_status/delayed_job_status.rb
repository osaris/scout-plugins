class DelayedJobStatus < Scout::Plugin  
  
  def build_report
    if @options["delayed_job_path"].nil? or @options["delayed_job_path"] == ""
      return error("Please specify the delayed_job path of the delayed_job worker you want to monitor.")
    end
    status_command   = "ruby " + @options["delayed_job_path"] + " status"
    begin
      status_output    = `#{status_command}`
    rescue Exception => error
      error("Couldn't use `status` as expected.", error.message)
    end
    
    if status_output =~ /DelayedJobWorker is running/
      status = 1
    else
      status = 0
    end
    report(:status => status)
    
    body = "Last output of delayed_job status command is #{status_output}"
    subject = "DelayedJob worker is "
    subject += (status == 1 ? "up" : "down")
    # send an alert only on status change between two runs
    alert(:subject => subject, :body => body) if (status != memory(:status))
    
    # remember status for next run
    remember(:status => status)
  end
end