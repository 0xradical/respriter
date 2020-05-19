module Napoleon::Automatum
  class IteratorStart < Base
    def extract_data(context, tokens)
      context.iterated_context
    end

    def further_match
      'an iterator'
    end
  end

  class IteratorClose < Base
    def extract_data(context, tokens)
      context.parent
    end

    def further_match
      'an iterator'
    end
  end
end
