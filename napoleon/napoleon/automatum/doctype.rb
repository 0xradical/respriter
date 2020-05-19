module Napoleon::Automatum
  class Doctype < StringAutomatum
    def further_match
      'a Doctype'
    end
  end
end
