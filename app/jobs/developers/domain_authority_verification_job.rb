require 'dnsruby'
require 'syslogger'

module Developers
  class DomainAuthorityVerificationJob < Que::Job
    class Error < StandardError; end
    SERVICE_NAME = 'domain-validation-service'

    self.priority = 100

    attr_reader :logger

    def initialize(*)
      super

      @logger = SysLogger.new
    end

    def run(id, user_id)
      log(id, 'Started domain verification')

      crawler_domain = CrawlerDomain.find(id)
      user_account = UserAccount.find(user_id)

      if crawler_domain.authority_confirmation_status == 'unconfirmed'
        crawler_domain.update(authority_confirmation_status: 'confirming')
      end

      resolver = Dnsruby::DNS.new

      authority_confirmed_via_dns = false
      authority_confirmed_via_html = false

      # DNS by TXT entry
      begin
        log(id, 'Verifying TXT DNS entries')
        resolver.each_resource(crawler_domain.domain, 'TXT') do |rr|
          if rr.data == crawler_domain.authority_txt
            authority_confirmed_via_dns = true
            break
          end
        end
      rescue Exception => e
        log(id, 'Could not verify via TXT DNS entries')
        nil
      end

      if !authority_confirmed_via_dns
        # DNS by CNAME entry
        log(id, 'Could not verify via TXT DNS entries, trying CNAME entries')
        begin
          resolver.each_resource(
            crawler_domain.authority_cname,
            'CNAME'
          ) do |rr|
            if rr.rdata.to_s == 'verification.classpert.com'
              authority_confirmed_via_dns = true
              break
            end
          end
        rescue Exception => e
          log(id, 'Could not verify via CNAME DNS entries')
        end
      end

      if authority_confirmed_via_dns
        confirm!(user_id, crawler_domain, 'dns')
        log(id, 'Successfully verified domain via DNS')
      else
        log(id, 'Could not verify via CNAME DNS entries, trying HTML method')
        # try via HTML
        # try HTTP + HTTPS
        uri = URI.parse(crawler_domain.domain)

        if uri.scheme.nil? && uri.host.nil?
          if uri.path
            uri.scheme = 'https'
            uri.host = uri.path
            uri.path = ''
          end
        end

        [uri, uri.dup.tap { |u| u.scheme = 'http' }].each do |u|
          break if authority_confirmed_via_html

          begin
            response = Net::HTTP.get_response(URI.parse(u.to_s))

            if response.code == '200'
              document = Nokogiri.HTML(response.body)

              document.css('meta').each do |meta|
                if meta.attributes['name']&.value ==
                     CrawlerDomain::DOMAIN_VERIFICATION_KEY &&
                     meta.attributes['content']&.value ==
                       crawler_domain.authority_confirmation_token
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
          confirm!(user_id, crawler_domain, 'html')
          log(id, 'Successfully verified domain via HTML')
        else
          if error_count < 10
            crawler_domain.update(authority_confirmation_status: 'unconfirmed')
            log(id, 'Could not verify domain, will try again shortly')

            raise DomainAuthorityVerificationJob::Error
          else
            CrawlerDomain.transaction do
              crawler_domain.update(authority_confirmation_status: 'failed')
              expire
            end

            log(id, 'Could not verify domain, exceeded number of tries')
          end
        end
      end
    end

    def confirm!(user_id, crawler_domain, confirmation_method)
      ApplicationRecord.transaction do
        provider = Provider.create

        provider_crawler =
          ProviderCrawler.create(
            { provider_id: provider.id, user_account_ids: [user_id] }
          )

        crawler_domain.update(
          {
            authority_confirmation_status: 'confirmed',
            authority_confirmation_method: confirmation_method,
            authority_confirmation_token:
              crawler_domain.authority_confirmation_token,
            authority_confirmation_salt: ENV['DOMAIN_VERIFICATION_SALT'],
            provider_crawler_id: provider_crawler.id
          }
        )

        finish # or destroy
      end
    end

    def log(ctx_id, message)
      self.logger.info(
        {
          id: SecureRandom.uuid,
          ps: { id: ctx_id, name: SERVICE_NAME },
          payload: message
        }.to_json
      )
    end
  end
end
