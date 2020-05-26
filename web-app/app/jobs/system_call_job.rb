class SystemCallJob < ActiveJob::Base

  def perform(command)
    system command + ' ' + '__ORIGIN__=admin'
  end

end
