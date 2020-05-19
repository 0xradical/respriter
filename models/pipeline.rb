class Pipeline < ApplicationRecord
  include CustomScriptRunner
  include SQLExecute

  belongs_to :schedule_pipeline_template, class_name: :PipelineTemplate
  belongs_to :pipeline_template
  belongs_to :pipeline_execution
  belongs_to :dataset

  has_many :pipe_processes

  serialize :status,                Serializers::Symbol
  serialize :bootstrap_script_type, Serializers::Symbol
  serialize :waiting_script_type,   Serializers::Symbol
  serialize :success_script_type,   Serializers::Symbol
  serialize :fail_script_type,      Serializers::Symbol

  serialize :data,  Serializers::SymbolizedHash
  serialize :pipes, Serializers::Pipes

  def call!(status = nil, process_index = nil)
    return sql_execute "SELECT app.pipeline_call('#{id}', '#{status}', #{process_index});" if process_index.present?
    return sql_execute "SELECT app.pipeline_call('#{id}', '#{status}');"                   if status.present?
    sql_execute "SELECT app.pipeline_call('#{id}');"
  end

  def bootstrap!
    run_script bootstrap_script_type, bootstrap_script, filename: 'bootstrap'
  end

  def waiting!
    run_script waiting_script_type, waiting_script, filename: 'waiting'
  end

  def success!
    run_script success_script_type, success_script, filename: 'success'
  end

  def fail!
    run_script fail_script_type, fail_script, filename: 'fail'
  end

  def notify!
    webhook_url = ENV['SLACK_NOTIFICATION_WEBHOOK']
    return if webhook_url.blank?

    uri = URI.parse webhook_url
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request                 = Net::HTTP::Post.new uri.path
      request.body            = { text: "Pipeline (#{pipeline_template.name}/#{pipeline_execution.name})##{id} is now \"#{status}\"" }.to_json
      request['Content-Type'] = 'application/json'
      http.request request
    end
  end

  def virtual_source_folder
    "db/pipelines/#{self.id}"
  end

  ['bootstrap', 'waiting', 'success', 'fail', 'notify'].each do |event|
    eval %{
      class #{event.camelcase}Job < Que::Job
        self.priority = 50

        self.maximum_retry_count = 0

        def run(id)
          Pipeline.find_by(id: id)&.#{event}!
        end
      end
    }
  end
end
