require 'socket'

class Notes
  class Web
    attr_accessor :app, :hash
    def initialize(app, hash)
      @hash = hash
      @server = TCPServer.new hash[:Host], hash[:Port]
      @app = app
    end

    def stop
      @server.close
    end

    def start
      loop do
        socket = @server.accept
        env = Notes::Web.parser(socket)
        status, headers, body = app.call(env)
        Notes::Web.printer(socket, status, headers, body)
        socket.close
      end
    end

    def self.printer(socket, status, headers, body)
      socket.print "HTTP/1.1 #{status} some text goes here *shrug*\r\n"
      headers.each { |key, value| socket.print "#{key}: #{value}\r\n" }
      socket.print "\r\n"
      body.each { |line| socket.print line }
    end

    def self.parser(socket)
      env = {}
      method, path, version = socket.gets.split
      env['REQUEST_METHOD'] = method
      env['PATH_INFO'] = path
      env['VERSION'] = version
      #env['QUERY_STRING']
      until (line = socket.gets) == "\r\n" do
        header_values = line.split(':')
        key = header_values[0]
        value = header_values[1..-1].join.strip
        env[key] = value
      end
      body = socket.read(env["Content-Length"].to_i)
      env["Body"] = body
      env
    end
  end
end





