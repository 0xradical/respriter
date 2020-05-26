require_relative 'path_info_interceptor'

class RobotsTxtInterceptor

  include PathInfoInterceptor

  def initialize(app)
    @app, @rewrite_path = app, "/robots/%{locale}/robots.txt"
  end

  def call(env)
    @env = env; set_locale
    env['PATH_INFO'] = set_new_path_info if env['PATH_INFO'].eql?('/robots.txt')
    @app.call(env)
  end

end
