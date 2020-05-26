module PathInfoInterceptor

  def requesting?(path)
    @env['PATH_INFO'].eql?(path)
  end

  def set_new_path_info
    (@rewrite_path % { locale: @locale }).squeeze('/')
  end

  def set_locale
    I18nHost.new(@env['HTTP_HOST']).each do |locale, host|
      @locale = locale if host.eql?(@env['HTTP_HOST'])
    end
  end

end
