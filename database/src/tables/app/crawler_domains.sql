CREATE TABLE app.crawler_domains (
  id                            uuid                              DEFAULT    public.uuid_generate_v1() PRIMARY KEY,
  provider_crawler_id           uuid                              REFERENCES app.provider_crawlers(id) ON DELETE CASCADE NOT NULL ,
  authority_confirmation_status app.authority_confirmation_status DEFAULT    'unconfirmed'                               NOT NULL,
  authority_confirmation_token  uuid                              DEFAULT    public.uuid_generate_v4()                   NOT NULL,
  authority_confirmation_method app.authority_confirmation_method DEFAULT    'dns'                                       NOT NULL,
  created_at                    timestamptz                       DEFAULT    NOW()                                       NOT NULL,
  updated_at                    timestamptz                       DEFAULT    NOW()                                       NOT NULL,
  domain                        varchar                                                                                  NOT NULL,

  CONSTRAINT domain__must_be_a_domain CHECK ( domain ~ '^([a-z0-9\-\_]+\.)+[a-z]+$' )
);
