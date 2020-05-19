require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

require_relative './app'

ActiveRecord::Base.schema_format = :sql

namespace :db do
  task :load_config do
    require_relative './app'
  end
end
