class SessionTracker
  TRACKED_PROPERTIES = [
    :id, :cookie_id,
    :ip, :utm, :cf_ipcountry, :http_accept_language,
    :referer, :query_string, :user_agent,
    :first_access_at, :last_access_at, :session_count, :session_started_at
  ]
  UTM_REGEX = /(utm_campaign|utm_source|utm_medium|utm_content|utm_term)=([a-zA-Z0-9\-._~:\/?#\[\]@!$'\(\)*+,\;=]*)&?/

  delegate :request, :session, :cookies, to: :action
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def track
    session[:tracking_data]                  = truncate_payload session_payload
    cookies.signed.permanent[:tracking_data] = Base64.encode64 Marshal.dump truncate_payload cookies_payload
  end

  def [](key)
    session_payload[key]
  end

  def session_payload
    return @session_payload if @session_payload.present?

    @session_payload = if session[:tracking_data].present?
     session[:tracking_data].deep_dup
    else
      TRACKED_PROPERTIES.inject(raw) do |tracking_obj, property|
        tracking_obj.merge send("parse_#{property}")
      end.with_indifferent_access
    end
  end

  def cookies_payload
    return @cookies_payload if @cookies_payload.present?

    @cookies_payload = if had_cookies?
      tracking_cookies.merge session_payload.slice(:session_count, :last_access_at)
    else
      session_payload.deep_dup
    end
  end

  def store_third_party_cookies!
    @session_payload['third_party_cookies'] = Hash[cookies.filter { |k,v| !(k =~ /tracking_data|_app_session/) }.map do |k,v|
      [k, v]
    end]
  end

  def had_cookies?
    cookies.signed[:tracking_data].present?
  end

  def tracking_cookies
    @tracking_cookies ||= if had_cookies?
      Marshal.load Base64.decode64 cookies.signed[:tracking_data]
    else
      Hash.new
    end
  end

  def tracking_session
    @tracking_session ||= (session[:tracking_data].deep_dup || Hash.new).with_indifferent_access
  end

  def self.parse_http_accept_language_header(http_accept_language_header)
    return [:en] if http_accept_language_header.nil?
    http_accept_language_parser = HTTP::Accept::Languages.parse(http_accept_language_header)
    http_accept_language_parser&.map { |l| l&.locale.to_sym }
    rescue HTTP::Accept::ParseError => e
      Rails.logger.error "#{e.class} - #{e.message} (args: #{http_accept_language_header})".ansi(:red)
      return [:en]
  end

  protected
  def truncate_payload(payload)
    case payload
    when Array
      payload.map do |value|
        truncate_payload(value)
      end
    when Hash
      payload.map do |key, value|
        [
          key,
          truncate_payload(value)
        ]
      end.to_h
    when String
      payload.truncate 1000
    else
      payload
    end
  end

  def raw
    {
      raw: {
        accept_language:  request.env['HTTP_ACCEPT_LANGUAGE'],
        x_forwarded_for:  request.env['HTTP_X_FORWARDED_FOR'],
        cf_ipcountry:     request.env['HTTP_CF_IPCOUNTRY'],
        user_agent:       request.env['HTTP_USER_AGENT'],
        referer:          request.env['HTTP_REFERER']
      }
    }
  end

  def parse_id
    { id: tracking_session[:id] || SecureRandom.uuid }
  end

  def parse_cookie_id
    { cookie_id: tracking_cookies[:cookie_id] || SecureRandom.uuid }
  end

  def parse_http_accept_language
    {
      preferred_languages: self.class.parse_http_accept_language_header(request.env['HTTP_ACCEPT_LANGUAGE']) 
    }
  end

  # Cloudflare's GeoIP special header
  def parse_cf_ipcountry
    { country: request.env['HTTP_CF_IPCOUNTRY'] }
  end

  def parse_ip
    { ip: ((request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip).to_s).scan(/(.*),|\A(.*)\z/).flatten.compact.first }
  end

  def parse_utm
    Hash[request.query_string.scan(UTM_REGEX)]
  end

  def parse_referer
    { referer: request.referer&.split('?')&.first }
  end

  def parse_query_string
    { query_string: request.query_string }
  end

  def parse_user_agent
    user_agent_parser = UserAgentParser.parse(request.user_agent)
    { user_agent: { browser: user_agent_parser.to_s, os: user_agent_parser.os.to_s } }
  end

  def parse_first_access_at
    time = tracking_cookies[:first_access_at] || tracking_session[:first_access_at] || Time.current
    { first_access_at: time }
  end

  def parse_last_access_at
    { last_access_at: Time.current }
  end

  def parse_session_count
    session_count = if tracking_cookies.present?
      if tracking_session.present?
        tracking_cookies[:session_count]
      else
        (tracking_cookies[:session_count] || 0) + 1
      end
    else
      1
    end
    { session_count: session_count }
  end

  def parse_session_started_at
    time = tracking_session[:first_access_at] || Time.current
    { session_started_at: time }
  end

  private
  def request
    @action.send :request
  end

  def session
    @action.send :session
  end

  def cookies
    @action.send :cookies
  end

  def self.track(action)
    tracker = self.new action
    tracker.track
    tracker
  end
end
