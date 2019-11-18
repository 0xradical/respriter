module Developer
  class DomainAuthorityVerificationJob < Que::Job
    self.priority = 100

    def run(id)
      crawler_domain = CrawlerDomain.find(id)

      # substituir por codigo de verificacao
      # DNS + HTML
      CrawlerDomain.transaction do
        crawler_domain.update({
          authority_confirmation_status: 'confirmed',
          authority_confirmation_method: 'dns'
        })

        finish # or destroy
      end
    end
  end
end
