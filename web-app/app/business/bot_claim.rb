################################### Bot verification methods ####################################
# + Googlebot https://support.google.com/webmasters/answer/80553?hl=en                          #
# + Bingbot https://www.bing.com/webmaster/help/how-to-verify-bingbot-3905dc26                  #
# + YandexBot https://yandex.com/support/webmaster/robot-workings/check-yandex-robots.html      #
# + DuckDuckBot https://help.duckduckgo.com/duckduckgo-help-pages/results/duckduckbot/          #
#################################################################################################

class BotClaim

  class UnsupportedUserAgent < StandardError; end

  attr_reader :ip, :name

  @@trusted_claims = YAML::load_file(Rails.root.join('config','bot_verification_methods.yml'))

  def initialize(ua, ip)
    @ua, @verified, @ip = ua, false, ip
    parse_ua
    verify!
  end

  def verified?
    @verified
  end

  private

  def parse_ua
    @name = UserAgentParser.parse(@ua).name
  end

  def verify!
    raise UnsupportedUserAgent, "User agent \"#{@name}\" not listed on bot_verification_methods.yml" unless @@trusted_claims.keys.include?(@name.downcase)
    methods = @@trusted_claims[@name.downcase]['methods']
    @verified = methods.map do |name, args|
      send(:"verify_by_#{name}", args)
    end.reduce { |result, method| result || method }
  end

  def verify_by_reverse_dns_lookup(entries)
    host = Resolv.getname(@ip)
    entries.map do |entry|
      Resolv.getaddress(host).eql?(@ip) if host.match?(/#{entry}/)
    end.reduce { |result, entry| result || entry }
    rescue Resolv::ResolvError
      Rails.logger.info("Could not lookup host for #{inspect}")
      false
  end

  def verify_by_ip(entries)
    entries.include?(@ip)
  end

end
