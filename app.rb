require 'bundler'

require_relative './napoleon/configuration'

Bundler.require :default
Bundler.require Napoleon.config.environment

require_relative './napoleon'

require 'sinatra/json'
require 'sinatra/streaming'

class NapoleonApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  DEFAULT_TIMEZONE = 'Brasilia'

  set :bind, '0.0.0.0'
  set :database, Napoleon.config.database
  set :root, File.dirname(__FILE__)

  [
    './models/concerns/*.rb',
    './models/serializers/*.rb',
    './models/*.rb',
    './models/pipes/*.rb',
    './app/*.rb'
  ].each do |glob|
    Dir[glob].sort.each{ |file| require_relative(file) }
  end

  configure do
    Time.zone = DEFAULT_TIMEZONE
    ActiveRecord::Base.default_timezone = :local

    I18n::Backend::Simple.send :include, I18n::Backend::Fallbacks
    I18n.enforce_available_locales = false
    I18n.load_path                += Dir['./config/locales/*.yml']
    I18n.default_locale            = :'pt-BR'
    I18n.backend.load_translations
  end

  use Rack::UTF8Sanitizer

  get '/status' do
    json ok: true
  end

  use SchemaApp
  use ResourceApp
  use PipeProcessApp

  not_found do
    binding.pry if NapoleonApp.development? && env['REQUEST_URI'] != '/favicon.ico'
    status 404
    json error: :not_found
  end

  Que.connection = ActiveRecord
  run! if app_file == $0
end
