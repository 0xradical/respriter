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

  def [](key)
    payload[key]
  end

  def payload
    return @payload if @payload.present?

    @payload = TRACKED_PROPERTIES.inject(raw) do |tracking_obj, property|
      tracking_obj.merge send("parse_#{property}")
    end.with_indifferent_access
  end

  def track
    session[:tracking_data] = payload
    cookies.signed.permanent[:tracking_data] = Base64.encode64 Marshal.dump(payload)
  end

  protected

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
    return { preferred_languages: [:en] } if request.env['HTTP_ACCEPT_LANGUAGE'].nil?
    http_accept_language_parser = HTTP::Accept::Languages.parse(request.env['HTTP_ACCEPT_LANGUAGE'])
    { preferred_languages: http_accept_language_parser&.map { |l| l&.locale.to_sym } }
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
    time = tracking_cookies&.[](:first_access_at) || tracking_session[:first_access_at] || Time.current
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
        tracking_cookies[:session_count] = (tracking_cookies&.[](:session_count) || 0) + 1
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

  def tracking_cookies
    @tracking_cookies ||= if cookies.signed[:tracking_data].present?
      Marshal.load Base64.decode64 cookies.signed[:tracking_data]
    else
      Hash.new
    end
  end

  def tracking_session
    @tracking_session = (session[:tracking_data] || Hash.new).with_indifferent_access
  end

  def request
    @action.send :request
  end

  def session
    @action.send :session
  end

  def cookies
    @action.send(:cookies)
  end

  def self.track(action)
    tracker = self.new action
    tracker.track
    tracker
  end
end
