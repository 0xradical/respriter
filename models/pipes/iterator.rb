module Pipes
  class Iterator < Pipe
    def execute(pipe_process, accumulator)
      unless accumulator.present?
        return [
          :pending,
          { new_pipe_process: nil }
        ]
      end

      new_pipe_process = PipeProcess.create!(
        status:              :pending,
        process_index:       0,
        initial_accumulator: accumulator,
        pipeline_id:         pipe_process.pipeline_id
      )

      [
        :pending,
        { new_pipe_process: new_pipe_process.id }
      ]
    end
  end
end
