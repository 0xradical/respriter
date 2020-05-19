Mail.defaults do
  if Napoleon.config.environment == :test
    delivery_method :test
  else
    config = {
      address:              ENV['MAIL_ADDRESS'],
      port:                 ENV['MAIL_PORT'],
      domain:               ENV['MAIL_DOMAIN'],
      user_name:            ENV['MAIL_USER_NAME'],
      password:             ENV['MAIL_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: (ENV['MAIL_TLS'] == 'true')
    }

    delivery_method :smtp, config
  end
end
