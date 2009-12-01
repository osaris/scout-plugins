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
      report(:status => 1)
    else
      report(:status => 0)
    end
  end
end