require_relative '../app.rb'

require 'pry'

require 'rack/test'

require 'rspec'
require 'rspec/its'
require 'rspec/collection_matchers'
require 'webmock/rspec'

WebMock.disable_net_connect! allow_localhost: true, allow: ['s3.clspt', 'heavyload.service.test']
DatabaseCleaner.allow_remote_database_url = true

require 'shoulda/matchers'

ActiveRecord::Base.logger = nil

Dir['./spec/mocks/*.rb'].sort.each do |file|
  require file
end

Dir['./spec/support/*.rb'].sort.each do |file|
  require file
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library        :active_record
  end
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.include Shoulda::Matchers::ActiveModel,  type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model

  config.include FactoryBot::Syntax::Methods
  config.before(:suite){ FactoryBot.find_definitions }

  config.include Support::Que

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end
end
