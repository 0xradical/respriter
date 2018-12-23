class SessionTracker

  UTM_REGEX = /(utm_campaign|utm_source|utm_medium|utm_content|utm_term)=([a-zA-Z0-9\-._~:\/?#\[\]@!$'\(\)*+,\;=]*)&?/

  def initialize(request)
    @request = request
  end

  def track
    [:ip,:utm,:http_accept_language,:referer,:query_string,:user_agent].inject({}) do |tracking_obj, property|
      tracking_obj.merge send("track_#{property}")
    end.with_indifferent_access
  end

  private

  def track_http_accept_language
    { http_accept_language: HttpAcceptLanguageParser.parse(@request.env['HTTP_ACCEPT_LANGUAGE']) }
    rescue HttpAcceptLanguageParser::MissingHttpAcceptLanguageHeader
      { http_acccept_language: [] }
  end

  def track_ip
    { ip: ((@request.env['HTTP_X_FORWARDED_FOR'] || @request.remote_ip).to_s).scan(/(.*),|\A(.*)\z/).flatten.compact.first }
  end

  def track_utm
    Hash[@request.query_string.scan(UTM_REGEX)]
  end

  def track_referer
    { referer: @request.referer&.split('?')&.first }
  end

  def track_query_string
    { query_string: @request.query_string }
  end

  def track_user_agent
    user_agent_parser = UserAgentParser.parse(@request.user_agent)
    { user_agent: { browser: user_agent_parser.to_s, os: user_agent_parser.os.to_s } }
  end

end
