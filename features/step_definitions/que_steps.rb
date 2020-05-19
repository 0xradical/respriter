When /^background processor executes (.*) jobs?$/ do |job_class|
  run_background_jobs job_class: job_class, remove: true
end

When /^background processor executes (.*) jobs? after (\d+) (.*)$/ do |job_class, time_amount, time_unit|
  run_background_jobs at: (time_amount.to_i).public_send(time_unit).from_now, job_class: job_class, remove: true
end
