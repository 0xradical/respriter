module Napoleon

  def self.config(&settings)
    @@client = Client.new
    @@client.http = @@client.http.instance_eval(&settings)
    @@client
  end

  def self.client
    @@client
  end

  class Client

    class VersionNotSupported < RuntimeError; end;

    URI = "https://napoleon-the-crawler.herokuapp.com/resources/updates/%{global_sequence}"

    attr_accessor :http

    def initialize
      @http             = HTTP
      logger            = Logger.new(STDOUT)
      logger.formatter  = Logger::Formatter.new
      @logger           = ActiveSupport::TaggedLogging.new(logger)
    end

    def resources(global_sequence, &blk)
      started_at, count, errors, run = Time.now, 0, 0, SecureRandom.hex(4)
      log(:info,  "Pulling courses ...",["BEGIN","run.#{run}", "seq.#{global_sequence}".ansi(:blue)])
      loop do
        resources = JSON.parse(http.get(URI % {global_sequence: global_sequence}).body)
        break if resources.empty?
        resources.each do |resource|
          begin
            check_version!(resource['content']['version'])
            blk.call(resource)
          rescue VersionNotSupported, ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
            errors += 1
            log(:warn,  "Fail to process resource: #{e.message}", ["run.#{run}", "seq.#{global_sequence}".ansi(:blue), "err.#{errors}".ansi(:red)])
            log(:debug, "--inspect-- " + resource.to_s.ansi(:red), "err.#{errors}".ansi(:red))
            next
          end
          count += 1
        end
        global_sequence = resources.last['global_sequence']
      end
      run_time = Time.at((Time.now - started_at)).utc.strftime('%Hh %Mm %Ss')
      log(:info, "Bye! " + "Total: #{count} resources".ansi(:yellow) + " | " + (errors.zero? ? "Errors: #{errors.to_s}".ansi(:green) : "Errors: #{errors.to_s}".ansi(:red))+ " | " + "Took #{run_time}".ansi(:blue), ["END","run.#{run}", "seq.#{global_sequence}".ansi(:blue)])
    end

    def log(level, msg, tags=nil)
      @logger.tagged('Napoleon', *tags) { @logger.send(level, msg) }
    end

    def check_version!(v)
      raise VersionNotSupported, "version #{v} not supported" unless locked_version.map do |ver|
        Semantic::Version.new(v).satisfies?(ver)
      end.reduce(&:|)
    end

    def locked_version
      ['0.0.0','~> 1.0.0']
    end

  end

end

# Monkey Patch
class String
  def ansi(color)
    case color
      when :blue
       return "\033[34m#{self}\033[0m"
      when :red
        return "\033[31;1m#{self}\033[0m"
      when :yellow
        return "\033[33m#{self}\033[0m"
      when :green
        return "\033[32m#{self}\033[0m"
    end
  end
end
