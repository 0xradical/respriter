class CrawlerDomain < ApplicationRecord
  DOMAIN_VERIFICATION_KEY = 'classpert-site-verification'

  def authority_txt
    "#{DOMAIN_VERIFICATION_KEY}=#{self.authority_confirmation_token}"
  end

  def authority_cname
    "#{self.authority_confirmation_token}.#{self.domain}"
  end

  def authority_confirmation_token
    Digest::MD5.hexdigest("#{self.domain}#{ENV['DOMAIN_VERIFICATION_SALT']}")
  end
end
