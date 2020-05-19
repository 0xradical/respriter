module Support
  module Que
    def run_background_jobs(at: Time.now, job_class: nil, remove: false)
      ApplicationRecord.connection.execute('SELECT * FROM que_jobs').each do |result|
        if Time.parse(result['run_at']) < at
          if job_class.blank? || job_class == result['job_class']
            job = result['job_class'].constantize.new Hash.new
            job.run *JSON.parse(result['args']).deep_symbolize_keys
            ApplicationRecord.connection.execute("DELETE FROM que_jobs WHERE id = '#{result['id']}'") if remove
          end
        end
      end
    end
  end
end
