class PipelineExecution < ApplicationRecord
  has_many   :pipelines

  belongs_to :pipeline_template
  belongs_to :dataset

  def call!
    ApplicationRecord.connection.execute call_query
  end

  protected
  def call_query
    ApplicationRecord.sanitize_sql [
      'SELECT app.pipeline_execution_invoke_call(?::uuid);',
      id
    ]
  end

  class CallJob < Que::Job
    self.maximum_retry_count = 0

    def run(id, **options)
      PipelineExecution.find_by(id: id)&.call!
    end
  end
end
