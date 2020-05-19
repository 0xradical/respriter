require 'pg'
require 'yaml'

conn = PG.connect({
  :dbname => ENV['POSTGRES_DB'],
  :host => ENV['POSTGRES_HOST'],
  :user => ENV['POSTGRES_USER'],
  :password => ENV['POSTGRES_PASSWORD']
})

Pipeline = Struct.new(:label, :status, :succeeded_count, :failed_count, :pipes) do
  def initialize(*)
    super
    self.pipes ||= []
  end
end
PipeProcess = Struct.new(:id, :process_index, :error_backtrace, :initial_accumulator, :last_accumulator, :status) do
  def error_backtrace
    YAML.load(self[:error_backtrace]).keys
  rescue
    nil
  end
  def initial_accumulator
    YAML.load(self[:initial_accumulator] || '{}')
  end
  def last_accumulator
    YAML.load(self[:last_accumulator] || '{}')
  end
end

def pipeline_analysis(conn)
  result = conn.exec(%Q{
    SELECT pipe_processes.id AS pipe_id,
           pipe_processes.process_index AS pipe_index,
           pipe_processes.error_backtrace AS pipe_error,
           pipe_processes.initial_accumulator AS pipe_initial_accumulator,
           pipe_processes.last_accumulator AS pipe_last_accumulator,
           pipe_processes.status AS pipe_status,
           pipelines.id AS pipeline_id,
           pipelines.label AS pipeline_label,
           pipelines.status AS pipeline_status,
           pipelines.succeeded_count AS pipeline_succeeded_count,
           pipelines.failed_count AS pipeline_failed_count
    FROM pipe_processes
    INNER JOIN pipelines ON pipelines.id = pipe_processes.pipeline_id
    INNER JOIN datasets  ON datasets.id  = pipelines.dataset_id
    WHERE datasets.name = 'Coursera'
    ORDER BY pipelines.created_at DESC, pipe_processes.created_at
  })

  pipelines = {}

  result.each do |row|
    pipelines[row['pipeline_id']] ||= Pipeline.new(*row.values_at(*%w(pipeline_label pipeline_status pipeline_succeeded_count pipeline_failed_count)))
    pipelines[row['pipeline_id']]['pipes'] << PipeProcess.new(*row.values_at(*%w(pipe_id pipe_index pipe_error pipe_initial_accumulator pipe_last_accumulator pipe_status)))
  end

  pipelines.each do |_, pipeline|
    puts "-----------------------------"
    puts "Pipeline #{pipeline.label}"
    puts " Status: #{pipeline.status}"
    puts " Succeeded: #{pipeline.succeeded_count}"
    puts " Failed: #{pipeline.failed_count}"
    pipeline.pipes.each do |pipe|
      next unless pipe.status == 'failed'
      puts "    Pipe Process #{pipe.id}"
      puts "      Last Pipe Process Index: #{pipe.process_index}"
      if pipe.initial_accumulator['url']
        puts "      URL: #{pipe.initial_accumulator['url']}"
      end
      if pipe.last_accumulator['status_code']
        puts "      HTTP Status Code: #{pipe.last_accumulator['status_code']}"
      end
      if pipe.error_backtrace && pipe.error_backtrace[0] != 'PipeProcess failed silently'
        puts "      Error Backtrace:"
        puts "        Error: #{pipe.error_backtrace[0]}"
        puts "        Where: #{pipe.error_backtrace[1]}"
      end
      if pipe.last_accumulator['validation_errors']&.keys&.size&.>0
        puts "      Validation Errors:"
        pipe.last_accumulator['validation_errors'].each do |field, errors|
          puts "        Field #{field}:"
          errors.each do |error|
            puts "          Details: #{field} #{error['details']}"
            puts "          Value: #{error['value'].inspect}"
            if error['extra'].size > 0
              puts "          Extra: #{error['extra'].inspect}"
            end
          end
        end
      end
    end
  end; nil
end

pipeline_analysis(conn)