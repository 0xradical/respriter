class CrawlerDomain < ApplicationRecord
  DOMAIN_VERIFICATION_KEY = 'classpert-site-verification'

  def verification_dns_entry
    "#{DOMAIN_VERIFICATION_KEY}=#{self.authority_confirmation_token}"
  end

  def authority_cname
    "#{self.authority_confirmation_token}.#{self.domain}"
  end
end