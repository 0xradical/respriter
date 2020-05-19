module Napoleon::Automatum
  class Comment < StringAutomatum
    def further_match
      "a Comment starting with #{content_to_match.truncate 60}"
    end
  end
end
