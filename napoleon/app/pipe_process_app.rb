class PipeProcessApp < BaseApp
  # TODO: Move it to PostgREST

  use Rack::Auth::Basic, 'Authentication Required' do |username, password|
    User.authenticated? username, password
  end

  post '/pipe_processes/stop_all' do
    # TODO: Handle it by PipelineExecution
    label = params.fetch :label

    response['Content-Type'] = 'application/json'
    stream do |out|
      QueJobStoper.new(out, label).call
    end
  end

  class QueJobStoper
    def initialize(stream, label, batch_size = 500)
      @stream, @label, @batch_size = stream, label, batch_size
    end

    def each(&block)
      query = stop_all_query_by_label
      deleted = 0
      loop do
        results = ApplicationRecord.connection.execute query
        break if results.cmd_tuples == 0
        deleted += results.cmd_tuples
        yield( { deleted_entries: deleted }.to_json + "\n" )
      end
      yield({ deleted_entries: deleted, finished: true }.to_json + "\n")
    end

    def call
      query = stop_all_query_by_label
      loop do
        results = ApplicationRecord.connection.execute query
        break if results.cmd_tuples == 0
        @stream << ({ deleted_entries: results.cmd_tuples }.to_json + "\n")
      end
      @stream << ({ finished: true }.to_json + "\n")
    end

    protected
    def stop_all_query_by_label
      ApplicationRecord.sanitize_sql([
        %{
          DELETE FROM que_jobs
          WHERE id IN (
            SELECT id
            FROM que_jobs job
            WHERE
              job.job_class = ANY( ARRAY['PipeProcess::CallJob', 'PipeProcess::RetryJob'] )
              AND args->1->>'label' = ?
            ORDER BY run_at ASC, priority ASC
            LIMIT ?
          )
        },
        @label,
        @batch_size
      ])
    end
  end
end
