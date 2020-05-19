module Pipes
  class Noop < Pipe
    def execute(pipe_process, accumulator)
      [ options[:status].to_sym, accumulator ]
    end

    protected
    def default_options
      { status: :waiting }
    end
  end
end
