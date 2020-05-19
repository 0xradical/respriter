module Napoleon::Automatum
  class CDATA < StringAutomatum
    def further_match
      "a CDATA starting with #{content_to_match.truncate 60}"
    end
  end
end
