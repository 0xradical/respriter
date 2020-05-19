class Pipe
  attr_reader :options

  def initialize(options)
    @options = default_options.merge(options.deep_symbolize_keys)
  end

  def call(pipe_process)
    if has_modifier_script?
      Pipe::ExecutionContext.run self, pipe_process
    else
      pipe_process.status, pipe_process.accumulator = execute pipe_process, pipe_process.accumulator
    end

  rescue CustomScriptRunner::ScriptError => error
    raise error.error if error.error.is_a?(Pipe::Error)
    raise Pipe::Error.new :failed, error
  rescue Pipe::Error => error
    raise error
  rescue
    raise Pipe::Error.new :failed, $!
  end

  def ==(other)
    self.class == other.class && @options == other.options
  end

  def max_retries
    options[:max_retries]
  end

  def has_modifier_script?
    options[:script].present?
  end

  def default_options
    Hash.new
  end

  def execute(pipe_process, accumulator)
    raise NotImplementedError
  end

  class ExecutionContext
    include CustomScriptRunner
    include SQLExecute

    attr_reader :pipe, :pipe_process

    delegate :pipeline, :retry!, :retried?, :retried_at?, to: :pipe_process

    def virtual_source_folder
      'db/pipe_processes'
    end

    def run(pipe, pipe_process)
      @pipe, @pipe_process = pipe, pipe_process
      pipe_process.status = :pending
      script = pipe.options[:script]
      run_script script[:type], script[:source_code], filename: "#{pipe_process.process_index}"
    end

    def public_validator(kind, version)
      schema = ResourceSchema.where(dataset_id: pipeline.dataset_id, kind: kind, schema_version: version).first
      return nil unless schema

      JSONSchemer.schema schema.public_specification, insert_property_defaults: true
    end

    def private_validator(kind, version)
      schema = ResourceSchema.where(dataset_id: pipeline.dataset_id, kind: kind, schema_version: version).first
      return nil unless schema

      JSONSchemer.schema schema.specification, insert_property_defaults: true
    end

    def call
      pipe_process.status, pipe_process.accumulator = execute pipe_process.accumulator
    end

    def execute(accumulator)
      pipe.execute pipe_process, accumulator
    end

    def self.run(pipe, pipe_process)
      self.new.run pipe, pipe_process
    end
  end

  class Error < StandardError
    attr_reader :status, :error

    def initialize(status, message_or_error)
      @status = status.to_sym
      if message_or_error.is_a?(StandardError)
        @error = message_or_error
      else
        super message_or_error
      end
    end

    def message
      return super unless @error
      @error.message
    end

    def backtrace
      return super unless @error
      @error.backtrace
    end

    def message_and_backtrace
      [ message, *backtrace ]
    end
  end
end
