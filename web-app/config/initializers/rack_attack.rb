# frozen_string_literal: true
class Rack::Attack

  ALLOW_PERIOD_FOR_TRUSTED_BOTS_IN_DAYS   = ENV.fetch('RACK_ATTACK__ALLOW_PERIOD_FOR_TRUSTED_BOTS_IN_DAYS') { 120 }
  THROTTLE_LEVELS                         = ENV.fetch('RACK_ATTACK__THROTTLE_LEVELS')                       { 4   }
  THROTTLE_LIMIT                          = ENV.fetch('RACK_ATTACK__THROTTLE_LIMIT')                        { 150 }
  THROTTLE_PERIOD                         = ENV.fetch('RACK_ATTACK__THROTTLE_PERIOD_IN_MINUTES')            { 15  }
  THROTTLE_BAN_PERIOD_FOR_ABUSE_IN_DAYS   = ENV.fetch('RACK_ATTACK__THROTTLE_BAN_PERIOD_FOR_ABUSE_IN_DAYS') { 120 }

  self.cache.prefix = "ra"
  self.cache.store  = ActiveSupport::Cache::RedisCacheStore.new({ url: ENV['REDIS_URL'] })

  safelist("allowed IPs") do |req|
    self.cache.read("allow:#{req.remote_ip}")
  end

  blocklist("blocked IPs") do |req|
    self.cache.read("block:#{req.remote_ip}")
  end

  (1..THROTTLE_LEVELS).each do |level|

    limit   = THROTTLE_LIMIT * level
    period  = (THROTTLE_PERIOD * level).minutes

    throttle("#{limit}req/ip/#{period}sec", :limit => limit, :period => period) do |req|

      cache_key = "#{Time.now.to_i/period}:#{limit}req/ip/#{period}sec:#{req.remote_ip}"

      unless req.path.start_with?('/assets')
        if req.browser.bot?
          inspector = BotInspector.new(req.remote_ip)
          if inspector.trusted_claim?
            self.cache.write(
              "allow:#{req.remote_ip}", 
              "#{req.browser.name}+#{req.user_agent}+#{req.country}", 
              Time.now + ALLOW_PERIOD_FOR_TRUSTED_BOTS_IN_DAYS.days
            )
            next
          end
        end

        actual_reqs = self.cache.read(cache_key).to_i

        if (actual_reqs >= limit)
          acc = self.cache.read("throttled:#{req.remote_ip}+#{req.user_agent}+#{req.country}").to_i
          self.cache.write("throttled:#{req.remote_ip}+#{req.user_agent}+#{req.country}", acc + actual_reqs, Time.now + 1.year)

          max_limit = THROTTLE_LEVELS * THROTTLE_LIMIT

          if actual_reqs >= max_limit
            self.cache.write(
              "block:#{req.remote_ip}",
              "#{actual_reqs}+#{req.browser.name}+#{req.user_agent}+#{req.country}", 
              (Time.now + THROTTLE_BAN_PERIOD_FOR_ABUSE_IN_DAYS.days)
            )
          end
        end

        req.remote_ip
      end

    end
  end

  class Request < ::Rack::Request

    def remote_ip
      (env['HTTP_X_FORWARDED_FOR'] || request.remote_ip).to_s.scan(/(.*),|\A(.*)\z/).flatten.compact.first
    end

    def browser
      Browser.new(user_agent)
    end

    def user_agent
      env['HTTP_USER_AGENT']
    end

    def country
      env['HTTP_CF_COUNTRY']
    end

  end

end
