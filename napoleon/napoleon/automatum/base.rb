module Napoleon::Automatum
  class Base
    attr_reader :first_state, :last_state

    def initialize(first_state, last_state)
      @first_state, @last_state = first_state, last_state
    end

    def match(tokens, index)
      [ index, 0 ]
    end

    def extract_data(context, tokens)
      context
    end

    def expected_type
      self.class.name.demodulize.to_sym
    end

    def ==(other)
      self.class   == other.class &&
      @first_state == other.first_state &&
      @last_state  == other.last_state
    end

    def dot_label
      detail = inspect_detail
      detail = detail.is_a?(String) ? detail.try(:truncate, 20) : detail
      detail = detail.present? ? " #{detail}" : nil
      label = "#{self.class.name.demodulize.to_sym} #{detail}"
      "[label=\"#{ label.to_s.gsub("\\", "\\\\").gsub("\"", "\\\"") }\"]"
    end

    def inspect_detail
    end

    def further_match
      inspect
    end

    def expecting
      nil
    end

    def inspect
      detail = inspect_detail
      detail = detail.is_a?(String) ? detail.try(:inspect).try(:truncate, 20) : detail
      detail = detail.present? ? " #{detail}" : nil
      "#<#{self.class.name.demodulize.to_sym}(#{@first_state}->#{@last_state})#{detail}>"
    end
  end
end
