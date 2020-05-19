module Pipes
  class Demux < Pipe
    def execute(pipe_process, accumulator)
      schedule = false
      entries  = []

      case accumulator
      when Hash
        schedule = !!accumulator[:schedule]
        entries  = accumulator[:entries]
      when Array
        schedule = false
        entries  = accumulator
      else
        raise 'Invalid accumulator on demux'
      end

      params = default_params(pipe_process).deep_merge options
      entry_params = entries.map{ |entry| params[:entry].merge entry.deep_symbolize_keys }

      if entry_params.empty?
        return [ params[:status].to_sym, { new_pipe_process_count: 0 } ]
      end

      results  = nil
      commited = false
      ApplicationRecord.transaction do
        results = PipeProcess.import entry_params, validate: false

        if schedule
          # TODO: Handle scheduling new processes in a better way
          results.ids.each{ |id| PipeProcess.find(id).enqueue }
        end

        commited = true
      end

      raise 'Something went wrong on PipeProcess import' unless commited

      [ params[:status].to_sym, { new_pipe_process_count: results.ids.count } ]
    end

    protected
    def default_params(pipe_process)
      {
        status: :pending,
        entry: {
          status:      :pending,
          pipeline_id: pipe_process.pipeline.data.try(:[], :next_pipeline_id)
        }
      }
    end
  end
end
