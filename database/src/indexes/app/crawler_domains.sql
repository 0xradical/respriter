CREATE UNIQUE INDEX app_crawler_domains_unique_domain_idx ON app.crawler_domains ( domain ) WHERE authority_confirmation_status = 'confirmed';
