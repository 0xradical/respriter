class BrowserSessionParser

  UTM_REGEX = /(utm_campaign|utm_source|utm_medium|utm_content|utm_term)=([a-zA-Z0-9\-._~:\/?#\[\]@!$'\(\)*+,\;=]*)&?/

  def initialize(request)
    @request = request
  end

  def call
    parsed_hash = [:ip, :utm, :cf_ipcountry, :http_accept_language, :referer, :query_string, :user_agent].inject(raw) do |tracking_obj, property|
      tracking_obj.merge send("parse_#{property}")
    end.with_indifferent_access
  end

  private

  def raw
    {
      raw: {
        accept_language:  @request.env['HTTP_ACCEPT_LANGUAGE'],
        x_forwarded_for:  @request.env['HTTP_X_FORWARDED_FOR'],
        cf_ipcountry:     @request.env['HTTP_CF_IPCOUNTRY'],
        user_agent:       @request.env['HTTP_USER_AGENT'],
        referer:          @request.env['HTTP_REFERER']
      }
    }
  end

  def parse_http_accept_language
    return { preferred_languages: [:en] } if @request.env['HTTP_ACCEPT_LANGUAGE'].nil?
    http_accept_language_parser = HTTP::Accept::Languages.parse(@request.env['HTTP_ACCEPT_LANGUAGE'])
    { preferred_languages: http_accept_language_parser&.map { |l| l&.locale.to_sym } }
  end

  # Cloudflare's GeoIP special header
  def parse_cf_ipcountry
    { country: @request.env['HTTP_CF_IPCOUNTRY'] }
  end

  def parse_ip
    { ip: ((@request.env['HTTP_X_FORWARDED_FOR'] || @request.remote_ip).to_s).scan(/(.*),|\A(.*)\z/).flatten.compact.first }
  end

  def parse_utm
    Hash[@request.query_string.scan(UTM_REGEX)]
  end

  def parse_referer
    { referer: @request.referer&.split('?')&.first }
  end

  def parse_query_string
    { query_string: @request.query_string }
  end

  def parse_user_agent
    user_agent_parser = UserAgentParser.parse(@request.user_agent)
    { user_agent: { browser: user_agent_parser.to_s, os: user_agent_parser.os.to_s } }
  end

end
