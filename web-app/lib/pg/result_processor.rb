require 'pg'

module PG
  class ResultProcessor
    CHECK_CONSTRAINT = /check constraint "(.*)"/
    UNIQUE_CONSTRAINT = /duplicate key value violates unique constraint "(.*)"/
    UNMAPPED_CONSTRAINT = 'unmapped_constraint'

    attr_reader :result

    def initialize(result)
      @result = result
    end

    def error_message
      self.result.error_field(PG::Result::PG_DIAG_MESSAGE_PRIMARY)
    end

    def error_detail
      self.result.error_field(PG::Result::PG_DIAG_MESSAGE_DETAIL)
    end

    def error_hint
      self.result.error_field(PG::Result::PG_DIAG_MESSAGE_HINT)
    end

    def error
      error_constraint = nil

      if (self.error_message && self.error_message =~ CHECK_CONSTRAINT)
        error_constraint = $1
      end

      if (self.error_message && self.error_message =~ UNIQUE_CONSTRAINT)
        error_constraint = $1
      end

      error_constraint || UNMAPPED_CONSTRAINT
    end
  end
end
