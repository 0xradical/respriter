class Rack::Attack

  class Request < ::Rack::Request
    def remote_ip
      (env['HTTP_X_FORWARDED_FOR'] || request.remote_ip).to_s.scan(/(.*),|\A(.*)\z/).flatten.compact.first
    end
    def bot?
      Browser.new(env['HTTP_USER_AGENT']).bot?
    end
  end

  safelist("allowed IPs") do |req|
    self.cache.read("allow-#{req.remote_ip}")
  end

  blocklist("blocked IPs") do |req|
    self.cache.read("block-#{req.remote_ip}")
  end

  throttle("req/ip/humans", :limit => 20, :period => 8.seconds) do |req|
    req.remote_ip unless req.path.start_with?('/assets')
  end

  (1..4).each do |level|
    throttle("req/ip/bots/#{level}", :limit => (150 * level), :period => level.hour) do |req|
      cache_key = "#{Time.now.to_i/(level.hour)}:req/ip/bots/#{level}:#{req.remote_ip}"
      unless req.path.start_with?('/assets')
        if req.bot?
          begin
            bot_claim = BotClaim.new(req.user_agent, req.remote_ip)
            self.cache.write("allow-#{bot_claim.ip}", bot_claim.name, Time.now + 3.months) if bot_claim.verified?
          rescue BotClaim::UnsupportedUserAgent => e
            Rails.logger.info(e.message)
          end
          blacklist_ip_if_abused(cache_key, req.remote_ip, threshold: (150 * level), ban_time: Time.now + (7 * level).days)
          req.remote_ip
        else
          blacklist_ip_if_abused(cache_key, req.remote_ip, threshold: (150 * level), ban_time: Time.now + (7 * level).days)
          req.remote_ip
        end
      end
    end
  end

  def self.blacklist_ip_if_abused(key, ip, threshold:, ban_time:)
    if (self.cache.read(key).to_i > threshold)
      self.cache.write("block-#{ip}", 1, ban_time)
    end
  end

end
