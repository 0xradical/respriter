require 'dnsruby'

module Developer
  class DomainAuthorityVerificationJob < Que::Job
    self.priority = 100

    def run(id)
      crawler_domain = CrawlerDomain.find(id)

      resolver = Dnsruby::DNS.new

      authority_confirmed_via_dns = false
      authority_confirmed_via_html = false

      begin
        resolver.each_resource(crawler_domain.domain, 'TXT') do |rr|
          if rr.data == crawler_domain.verification_dns_entry
            authority_confirmed_via_dns = true
            break
          end
        end
      rescue Exception => e
        nil
      end

      if authority_confirmed_via_dns
        CrawlerDomain.transaction do
          crawler_domain.update({
            authority_confirmation_status: 'confirmed',
            authority_confirmation_method: 'dns'
          })

          finish # or destroy
        end
      else # try via HTML
        # try HTTP + HTTPS
        uri = URI.parse(crawler_domain.domain)

        if uri.scheme.nil? && uri.host.nil?
          if uri.path
            uri.scheme = "https"
            uri.host = uri.path
            uri.path = ""
          end
        end

        [ uri, uri.tap{|u| u.scheme = 'http' } ].each do |u|
          break if authority_confirmed_via_html

          begin
            response = Net::HTTP.get_response(uri)

            if response.code == '200'
              document = Nokogiri::HTML(response.body)

              document.css('meta').each do |meta|
                if meta[CrawlerDomain::DOMAIN_VERIFICATION_KEY] == crawler_domain.authority_confirmation_token
                  authority_confirmed_via_html = true
                  break
                end
              end
            end
          rescue StandardError
            false
          end
        end

        if authority_confirmed_via_html
          CrawlerDomain.transaction do
            crawler_domain.update({
              authority_confirmation_status: 'confirmed',
              authority_confirmation_method: 'html'
            })

            finish # or destroy
          end
        end
      end
    end
  end
end
