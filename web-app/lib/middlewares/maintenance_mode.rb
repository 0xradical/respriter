class MaintenanceMode

  WHITELISTED_PATHS = %w(/api/admin)

  def initialize(app)
    @app = app
  end

  def call(env)
    if is_a_whitelisted_path?(env) || allow_authenticated_access?(env)
      @app.call(env)
    else
      html = ActionView::Base.new.render(file: 'public/503.html')
      [503, {'Content-Type' => 'text/html'}, [html]]
    end
  end

  private

  def allow_authenticated_access?(env)
    env['QUERY_STRING'] =~ /secret=(.*)/
    $1 == ENV['MAINTENANCE_MODE_SECRET']
  end

  def is_a_whitelisted_path?(env)
    WHITELISTED_PATHS.map do |wpath|
      env['REQUEST_PATH'].include?(wpath)
    end.reduce(:&)
  end

end
