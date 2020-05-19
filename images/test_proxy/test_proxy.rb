require 'socket'
require 'uri'

class ProxyServer
  def run(port)
    @proxy = TCPServer.new port

    loop do
      session = @proxy.accept
      Thread.new session, &method(:handle_request)
    end

  rescue Interrupt
    puts 'Got Interrupt..'
  ensure
    if @proxy
      @proxy.shutdown
      puts 'Socket closed..'
    end

    puts 'Quitting...'
  end

  def handle_request(client)
    request_line = client.readline

    verb    = request_line[/^\w+/]
    url     = request_line[/^\w+\s+(\S+)/, 1]
    version = request_line[/HTTP\/(1\.\d)\s*$/, 1]
    uri     = URI::parse url
    port    = uri.port.nil? ? 80 : uri.port

    puts format(' %4s | %s', verb, url)

    server = Socket.tcp uri.host, port, connect_timeout: 3
    server.write "#{verb} #{uri.path}?#{uri.query} HTTP/#{version}\r\n"

    forward_request  client, server
    forward_response server, client
  ensure
    server.shutdown rescue nil
    client.shutdown rescue nil
  end

  def forward_request(source, destination)
    content_length = 0

    loop do
      line = source.readline
      puts line

      if line =~ /^Content-Length:\s+(\d+)\s*$/
        content_length = $1.to_i
      end

      if line =~ /^Proxy/i
        next
      elsif line =~ /^Connection:/i
        next
      elsif line.strip.empty?
        destination.write "Connection: close\r\n\r\n"

        if content_length >= 0
          destination.write source.read(content_length)
        end

        break
      else
        destination.write line
      end
    end
  end

  def forward_response(source, destination)
    loop do
      line = source.readline

      if line.strip.empty?
        destination.write "Via: 1.1 dumb_simple_proxy\r\n\r\n"
        break
      end

      destination.write line
    end

    buffer = ''
    loop do
      buffer = source.read 4048
      puts buffer
      destination.write buffer
      break if buffer.size < 4048
    end
  end
end

class TestServer
  def run(port)
    @server = TCPServer.new port

    loop do
      session = @server.accept
      Thread.new session, &method(:handle_request)
    end

  rescue Interrupt
    puts 'Got Interrupt..'
  ensure
    if @server
      @server.shutdown
      puts 'Socket closed..'
    end

    puts 'Quitting...'
  end

  def handle_request(session)
    request = session.gets
    puts request

    session.print "HTTP/1.1 200 OK\r\n"
    session.print "Content-Type: text/html\r\n"
    session.print "\r\n"
    session.print "http://proxyed#{ request.match(/GET (.*) HTTP/)[1] } was requested at #{ Time.now }"

  ensure
    session.shutdown rescue nil
  end
end

ProxyServer.new.run 8888

# if __FILE__ == $0
#   proxy_port, server_port = 8888, 9999
#   case ARGV.size
#   when 0
#   when 1
#     unless ARGV[0].match(/^\d+$/)
#       puts 'Usage: test_proxy.rb [proxy_port] [server_port]'
#       puts '       [proxy_port]  must be an integer'
#       puts '       [server_port] must be an integer'
#       exit 1
#     end
#
#     proxy_port = ARGV[0].to_i
#   when 2
#     unless ARGV[0].match(/^\d+$/) && ARGV[1].match(/^\d+$/)
#       puts 'Usage: test_proxy.rb [proxy_port] [server_port]'
#       puts '       [proxy_port]  must be an integer'
#       puts '       [server_port] must be an integer'
#       exit 1
#     end
#
#     proxy_port, server_port = ARGV.map &:to_i
#   else
#     puts 'Usage: test_proxy.rb [port]'
#     exit 1
#   end
#
#   if fork
#     TestServer.new.run server_port
#   else
#     ProxyServer.new.run proxy_port
#   end
# end
