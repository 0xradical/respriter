module Napoleon::Automatum
  class ProcessingInstruction < StringAutomatum
    def further_match
      'a ProcessingInstruction'
    end
  end
end
