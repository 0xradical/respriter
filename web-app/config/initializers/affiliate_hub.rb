AffiliateHub.setup do |config|

  config.debug_output = Rails.env.development?

  config.setup :rakuten_affiliate_network_v1 do |c|
    c.base_uri  = 'https://api.rakutenmarketing.com'
    c.username  = ENV['RAKUTEN_MARKETING_USERNAME']
    c.password  = ENV['RAKUTEN_MARKETING_PASSWORD']
    c.scope     = ENV['RAKUTEN_MARKETING_SCOPE']
    c.client_id = ENV['RAKUTEN_MARKETING_SID']
    c.authorization_basic_auth = ENV['RAKUTEN_TOKEN_REQUEST_AUTHORIZATION']
  end

  config.setup :impact_radius do |c|
    c.base_uri = "https://#{ENV['IMPACT_RADIUS_ACCOUNT_SID']}:#{ENV['IMPACT_RADIUS_AUTH_TOKEN']}@api.impact.com"
  end

  config.setup :awin do |c|
    c.base_uri     = 'https://api.awin.com'
    c.api_token    = ENV['AWIN_API_TOKEN']
    c.publisher_id = ENV['AWIN_PUBLISHER_ID']
  end

  config.setup :commission_junction_v3 do |c|
    c.base_uri = 'https://commission-detail.api.cj.com/v3'
    c.authorization_token = "Bearer #{ENV['CJ_ACCESS_TOKEN']}"
  end

  config.setup :shareasale_v22 do |c|
    c.base_uri      = 'https://api.shareasale.com/x.cfm'
    c.api_token     = ENV['SHARE_A_SALE_API_TOKEN']# KHOl9lhUNDJw9nR8'
    c.api_secret    = ENV['SHARE_A_SALE_API_SECRET']#'IHc1pb8a2DVcti6gIXd0vm3w3GIroe5f'
    c.affiliate_id  = ENV['SHARE_A_SALE_AFFILIATE_ID']
    c.format        = 'xml'
  end

end
