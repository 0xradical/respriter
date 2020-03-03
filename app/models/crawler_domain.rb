class CrawlerDomain < ApplicationRecord
  DOMAIN_VERIFICATION_KEY = 'classpert-site-verification'

  def authority_txt
    "#{DOMAIN_VERIFICATION_KEY}=#{self.authority_confirmation_token}"
  end

  def authority_cname
    "#{self.authority_confirmation_token}.#{
      PublicSuffix.parse(self.domain).domain
    }"
  rescue StandardError
    nil
  end

  def authority_confirmation_token
    Digest::MD5.hexdigest("#{self.domain}#{ENV['DOMAIN_VERIFICATION_SALT']}")
  end

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
