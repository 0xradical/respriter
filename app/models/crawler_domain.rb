class CrawlerDomain < ApplicationRecord
  DOMAIN_VERIFICATION_KEY = 'classpert-site-verification'

  def verification_dns_entry
    "#{DOMAIN_VERIFICATION_KEY}=#{self.authority_confirmation_token}"
  end
end