Napoleon.config do |c|
  c.basic_auth user: ENV['NAPOLEON_CRAWLER_BASIC_AUTH_USER'], pass: ENV['NAPOLEON_CRAWLER_BASIC_AUTH_PASS']
end
