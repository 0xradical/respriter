class HTMLScreenshooter
  def capture(url, format='png', options={})
    urlbox_apikey = ENV['URL_BOX_API_KEY']

    query = {
      :url         => url, # required - the url you want to screenshot
      :force       => options[:force], # optional - boolean - whether you want to generate a new screenshot rather than receive a previously cached one - this also overwrites the previously cached image
      :full_page   => options[:full_page], # optional - boolean - return a screenshot of the full screen
      :thumb_width => options[:thumb_width], # optional - number - thumbnail the resulting screenshot using this width in pixels
      :width       => options[:width], # optional - number - set viewport width to use (in pixels)
      :height      => options[:height], # optional - number - set viewport height to use (in pixels)
      :quality     => options[:quality] # optional - number (0-100) - set quality of the screenshot
    }

    query_string = query.
      sort_by {|s| s[0].to_s }.
      select {|s| s[1] }.
      map {|s| s.map {|v| encode_uri_component(v.to_s) }.join('=') }.
      join('&')

    response = Net::HTTP.get(URI("https://api.urlbox.io/v1/#{urlbox_apikey}/#{format}?#{query_string}"))

    tempfile = Tempfile.new([SecureRandom.uuid, '.png'])
    tempfile.binmode

    begin
      tempfile.write(response)
      tempfile.rewind
      value = yield(tempfile)
    ensure
      tempfile.close
      tempfile.unlink
    end

    value
  end

  private

  def encode_uri_component(val)
    URI.escape(val, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
end