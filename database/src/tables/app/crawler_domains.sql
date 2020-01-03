CREATE TABLE app.crawler_domains (
  id                            uuid                              DEFAULT    public.uuid_generate_v1() PRIMARY KEY,
  provider_crawler_id           uuid                              REFERENCES app.provider_crawlers(id) ON DELETE CASCADE,
  authority_confirmation_status app.authority_confirmation_status DEFAULT    'unconfirmed'                               NOT NULL,
  authority_confirmation_token  varchar,
  authority_confirmation_method app.authority_confirmation_method DEFAULT    'dns'                                       NOT NULL,
  authority_confirmation_salt   varchar,
  created_at                    timestamptz                       DEFAULT    NOW()                                       NOT NULL,
  updated_at                    timestamptz                       DEFAULT    NOW()                                       NOT NULL,
  domain                        varchar                                                                                  NOT NULL,

  CONSTRAINT domain__must_be_a_domain CHECK ( domain ~ '^([a-z0-9\-\_]+\.)+[a-z]+$' )
);
