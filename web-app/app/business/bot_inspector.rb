################################### Bot verification methods ####################################
# + Googlebot https://support.google.com/webmasters/answer/80553?hl=en                          #
# + Bingbot https://www.bing.com/webmaster/help/how-to-verify-bingbot-3905dc26                  #
# + YandexBot https://yandex.com/support/webmaster/robot-workings/check-yandex-robots.html      #
# + DuckDuckBot https://help.duckduckgo.com/duckduckgo-help-pages/results/duckduckbot/          #
#################################################################################################

class BotInspector

  attr_reader :ip, :name, :host

  @@methods = YAML::load_file(Rails.root.join('config','bot_inspector.yml'))

  def initialize(ip)
    @trusted, @ip = false, ip
    inspect!
  end

  def trusted_claim?
    @trusted
  end

  def inspect!
    @@methods.each do |name, args|
      @trusted = send(:"run_#{name}_method", args)
      break if @trusted
    end
  end

  def run_reverse_dns_lookup_method(entries)
    @host = Resolv.getname(@ip)
    entries.map do |entry|
      @host.match?(/#{entry}/) ? Resolv.getaddress(@host).eql?(@ip) : false
    end.reduce { |result, process| result || process }
    rescue Resolv::ResolvError => e
      false
  end

  def run_ip_method(entries)
    entries.include?(@ip)
  end

end
