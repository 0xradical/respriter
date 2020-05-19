module Napoleon
  module Search
    class Base
      attr_reader :graph

      def initialize(graph)
        @graph = graph
      end

      def search
        raise NotImplementedError
      end

      def last_path
        return @last_path unless @last_path.nil?
        search
      end
    end

    class NotFoundError < StandardError
      attr_reader   :closest_path
      attr_accessor :last_token, :graph

      delegate :tokens, :automata, to: :graph
      delegate :automatum,         to: :closest_path

      def initialize(closest_path = nil)
        @closest_path = closest_path
      end

      def message
        'Content could not be matched by given code'
      end

      def last_token_line
        last_token.options[:line]
      end

      def pretty_message
        return message unless last_token.present?

        pretty_message = "ERROR: #{message.red}\n"

        pretty_message << "further match was #{automatum.further_match.red}\n"

        expactations = automata.next_states(closest_path.position).map(&:expecting).compact
        if expactations.present?
          pretty_message << "could then have received:\n"
          expactations.each do |expectation|
            pretty_message << "  #{expectation.red}\n"
          end
        end

        pretty_message << "and got a token of type #{last_token.type.to_s.red}\n"
        pretty_message << "with value #{ last_token.value.to_s.gsub(/\s+/, ' ').strip.truncate(60).to_s.red }\n"

        if last_token_line.present?
          pretty_message << "near content line #{ last_token_line.to_s.red }\n"
        end

        # graph.automata.states.each_with_index{ |x,i| puts "#{i} #{x.inspect}" }; nil
        # puts pretty_message
        #
        # binding.pry

        pretty_message
      end
    end
  end
end
