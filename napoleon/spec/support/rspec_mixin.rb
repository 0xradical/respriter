RSpec::Matchers.define_negated_matcher :not_change, :change

module Support
  module RSpecMixin
    include Rack::Test::Methods

    def app
      NapoleonApp
    end
  end
end
