module Pipes
  class Mocked < Pipe
    attr_reader :options

    def execute(pipe_process, accumulator)
      evaluate(pipe_process, accumulator) if @options[:eval].present?
      raise @options[:raise]              if @options[:raise].present?

      [
        @options.fetch( :status,      :pending                ),
        @options.fetch( :accumulator, index: @options[:index] )
      ]
    end

    def evaluate(pipe_process, accumulator)
      instance_eval @options[:eval]
    end

    def self.random_pipes
      options = rand(1..5).times.map do
        {
          status:      PipeProcess::STATUSES.sample,
          accumulator: {
            lucky_number: rand(1..5),
            random_string: ['dice', 'lorem', 'mussum'].sample
          }
        }
      end
      pipes *options
    end

    def self.pipes(*pipes_options)
      pipes_options.each_with_index.map do |options, index|
        options ||= Hash.new
        self.new(options.merge(index: index))
      end
    end
  end
end