class PipelineTemplate < ApplicationRecord
  include CustomScriptRunner

  belongs_to :schedule_pipeline_template, class_name: :PipelineTemplate
  belongs_to :dataset
  has_many   :pipelines

  serialize :bootstrap_script_type, Serializers::Symbol
  serialize :waiting_script_type,   Serializers::Symbol
  serialize :success_script_type,   Serializers::Symbol
  serialize :fail_script_type,      Serializers::Symbol

  serialize :data,  Serializers::SymbolizedHash
  serialize :pipes, Serializers::Pipes
end
