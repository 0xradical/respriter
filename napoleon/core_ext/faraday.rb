class Faraday::Response
  def xml_response
    @xml_response ||= Nokogiri::XML(body)
  end
  alias :xml :xml_response

  def html_response
    @html_response ||= Nokogiri::HTML(body)
  end
  alias :html :html_response

  def json_response
    @json_response ||= HashWithIndifferentAccess[ JSON.parse body ]
  end
  alias :json :json_response
end
