class CrawlerDomain < ApplicationRecord
  def possible_uris
    uri = URI.parse(self.domain)

    if uri.scheme.nil? && uri.host.nil?
      if uri.path
        uri.scheme = 'https'
        uri.host = uri.path
        uri.path = ''
      end
    end

    # Generic URI to HTTP / HTTPS URIs
    [uri, uri.dup.tap { |u| u.scheme = 'http' }].map { |u| URI.parse(u.to_s) }
  rescue StandardError
    []
  end
end
