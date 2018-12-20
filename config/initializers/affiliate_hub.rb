AffiliateHub.setup do |config|

  config.debug_output = $stdout

  config.setup :rakuten_affiliate_network_v1 do |c|
    c.base_uri  = 'https://api.rakutenmarketing.com'
    c.username  = ENV['RAKUTEN_MARKETING_USERNAME']
    c.password  = ENV['RAKUTEN_MARKETING_PASSWORD']
    c.scope     = ENV['RAKUTEN_MARKETING_SCOPE']
    c.client_id = ENV['RAKUTEN_MARKETING_SID']
    c.authorization_basic_auth = ENV['RAKUTEN_TOKEN_REQUEST_AUTHORIZATION']
  end

  config.setup :impact_radius do |c|
    c.base_uri = "https://#{ENV['IMPACT_RADIUS_ACCOUNT_SID']}:#{ENV['IMPACT_RADIUS_AUTH_TOKEN']}@api.impactradius.com"
  end

  config.setup :awin do |c|
    c.base_uri     = 'https://api.awin.com'
    c.api_token    = ENV.fetch('AWIN_API_TOKEN')
    c.publisher_id = ENV.fetch('AWIN_PUBLISHER_ID')
  end


end
