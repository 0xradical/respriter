class PipeProcess < ApplicationRecord
  include SQLExecute

  STATUSES = [ :pending, :skipped, :waiting, :failed, :succeeded ]

  belongs_to :pipeline

  serialize :status, Serializers::Symbol

  serialize :data,                Serializers::SymbolizedHash
  serialize :accumulator,         Serializers::SymbolizedHash
  serialize :initial_accumulator, Serializers::SymbolizedHash
  serialize :last_data,           Serializers::SymbolizedHash
  serialize :last_accumulator,    Serializers::SymbolizedHash
  serialize :retried_in,          Serializers::SparseArray

  def reset!
    self.process_index = 0
    self.status        = :pending
    self.accumulator = self.data = self.last_accumulator = self.last_data = self.error_backtrace = nil
    save!
  end

  def call!
    raise 'missing pipes' if pipeline.pipes.empty?

    return if terminal_status?

    if process_index == 0 && accumulator.nil?
      self.accumulator = initial_accumulator
    end

    until terminal_status?
      begin
        transaction do
          self.last_accumulator = self.last_data = self.error_backtrace = nil

          pipe = pipeline.pipes[process_index]
          pipe.call self

          # TODO: In the future, this could be changed to provide branching execution on pipe processing
          if pending?
            if pipeline.pipes.size == self.process_index + 1
              self.status = :succeeded
            else
              self.process_index += 1
            end
          else
            unless succeeded?
              message_and_backtrace = failed? ? ['PipeProcess failed silently'] : nil
              handle_unsuccessful_status self.status, message_and_backtrace
            end
          end

          save!
        end
      rescue Pipe::Error => error
        transaction do
          handle_unsuccessful_status error.status, error.message_and_backtrace
          save!
        end
        break
      rescue
        transaction do
          self.reload
          self.status           = :failed
          self.error_backtrace  = [$!.message, *$!.backtrace]
          save!
        end
        break
      end
    end
  end

  def terminal_status?
    status.to_sym != :pending
  end

  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status.to_sym == status.to_sym
    end
  end

  def should_retry?
    @retry
  end

  def exceeded_retries?
    retry_limit_exceeded? || retry_pipe_limit_exceeded?
  end

  def retry!(message_or_error)
    @retry = true
    raise Pipe::Error.new(:pending, message_or_error)
  end

  def retried?
    total_retries > 0
  end

  def retried_at?(*indexes)
    indexes.any? do |index|
      retried_in[index] > 0
    end
  end

  def retried_after?(index)
    retried_in.any? do |i, count|
      i > index && retried_in[i] > 0
    end
  end

  def total_retries
    retried_in.values.sum
  end

  def retry_limit_exceeded?
    pipeline.max_retries.present? && total_retries >= pipeline.max_retries
  end

  def retry_pipe_limit_exceeded?
    pipeline.pipes.each_with_index.any? do |pipe, index|
      pipe.max_retries.present? && retried_in[index] >= pipe.max_retries
    end
  end

  def schedule_retry
    self.retried_in[process_index] += 1
    if exceeded_retries?
      self.status = :failed
      self.error_backtrace.unshift 'Exceeded retry attempts'
    else
      self.status = :pending
      enqueue_retry run_at: next_retry_attempt
    end
  end

  def enqueue
    PipeProcess::CallJob.enqueue self.id, job_indexes
  end

  def enqueue_retry(**options)
    PipeProcess::RetryJob.enqueue self.id, job_indexes, options
  end

  def job_indexes
    {
      pipeline_id:           pipeline_id,
      pipeline_execution_id: pipeline.pipeline_execution_id
    }
  end

  def next_retry_attempt
    # 8, 16, 32, 64, and so on...
    (8 << (total_retries - 1)).minutes.from_now
  end

  def handle_unsuccessful_status(last_status, message_and_backtrace)
    last_accumulator = self.accumulator
    last_data        = self.data
    should_retry     = should_retry?

    self.reload

    self.last_accumulator = last_accumulator
    self.last_data        = last_data
    self.status           = last_status
    self.error_backtrace  = message_and_backtrace

    schedule_retry if should_retry
  end

  class CallJob < Que::Job
    self.maximum_retry_count = 0

    def run(id, **options)
      PipeProcess.find_by(id: id)&.call!
    end
  end

  class RetryJob < Que::Job
    self.maximum_retry_count = 0

    def run(id, **options)
      pipe_process = PipeProcess.find_by id: id
      pipe_process&.reset!
      pipe_process&.call!
    end
  end
end
