require_relative '../../spec/spec_helper'

require 'cucumber'
require 'json_spec/cucumber'

NapoleonApp.set :environment, :test

class NapoleonWorld
  include Support::Que
  include Support::RSpecMixin

  include FactoryBot::Syntax::Methods
end

Napoleon::HTTPClient.new.clear_cache

World do
  NapoleonWorld.new
end

AfterConfiguration do |config|
  unless config.tag_expressions.include?('@ignore-webmock')
    require 'webmock/cucumber'
  end
end
