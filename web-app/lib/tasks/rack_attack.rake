namespace :rack_attack do

  PERIOD_REGEXP = /(?<value>\d*) (?<unit>seconds?|minutes?|hours?|days?|months?|years?)/

  namespace :blacklist do
    desc 'Add IPs to blacklist. Example: add[<ips>,<ban_period>]'
    task :add, %i[ips ban_period] => %i[environment] do |t,args|
      ban_period = PERIOD_REGEXP.match(args[:ban_period])

      unless ban_period
        raise ArgumentError, "Invalid ban_period. Format should be [value <unit:seconds|minutes|hours|days|months|years>]"
      end

      ban_time = Time.now + ban_period[:value].to_i.send(ban_period[:unit])
      args[:ips].split(',').each do |ip|
        Rack::Attack.cache.write("block-#{ip}",1,ban_time)
      end
    end

    desc 'Remove IPs from blacklist. Example: remove[<ips>]'
    task :remove, %i[ips] => %i[environment] do |t,args|
      args[:ips].split(',').each do |ip|
        Rack::Attack.cache.delete("block-#{ip}")
      end
    end
  end

  namespace :whitelist do
    desc 'Add IPs to whitelist. Example: add[<ips>,<allow_period>]'
    task :add, %i[ips allow_period] => %i[environment] do |t,args|
      allow_period = PERIOD_REGEXP.match(args[:allow_period])

      unless allow_period
        raise ArgumentError, "Invalid allow_period. Format should be [value <unit:seconds|minutes|hours|days|months|years>]"
      end

      allow_time = Time.now + allow_period[:value].to_i.send(allow_period[:unit])
      args[:ips].split(',').each do |ip|
        Rack::Attack.cache.write("allow-#{ip}",1,allow_time)
      end
    end

    desc 'Remove IPs to whitelist. Example: remove[<ips>]'
    task :remove, %i[ips] => %i[environment] do |t,args|
      args[:ips].split(',').each do |ip|
        Rack::Attack.cache.delete("allow-#{ip}")
      end
    end
  end

end
