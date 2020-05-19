class BaseApp < Sinatra::Base
  set :show_exceptions, false

  use Rack::PostBodyContentTypeParser

  before do
    Time.zone = NapoleonApp::DEFAULT_TIMEZONE
  end

  error StandardError do
    case error = env['sinatra.error']
    when ActiveRecord::RecordInvalid
      status 400
      json error.record.errors.messages
    when ActiveRecord::RecordNotFound
      status 404
      json error: :not_found
    else
      binding.pry if NapoleonApp.development?
      status 500
      json error: :internal
    end
  end

  def body_params
    @body_params ||= HashWithIndifferentAccess.new(env['rack.request.form_hash'] || Hash.new)
  end
end
