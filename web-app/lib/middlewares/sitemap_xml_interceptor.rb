require_relative 'path_info_interceptor'

class SitemapXmlInterceptor

  include PathInfoInterceptor

  def initialize(app)
    @app, @rewrite_path = app, "/sitemaps/%{locale}/sitemap.xml.gz"
  end

  def call(env)
    @env = env; set_locale
    env['PATH_INFO'] = set_new_path_info if env['PATH_INFO'].eql?('/sitemap.xml.gz')
    @app.call(env)
  end

end
