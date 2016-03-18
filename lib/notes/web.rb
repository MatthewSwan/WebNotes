require 'socket'

class Notes
  class Web
    attr_accessor :app
    def initialize(app, hash)
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
        status, headers, body = @app.call(env)
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
      method, url, version = socket.gets.split
      url_array = url.split("?", 2)
      path = url_array[0]
      query = url_array[1]
      if query != nil
        query_array = query.split("=")
        query = [query_array.pop]
      else
        query = ["add"]
      end

      #query = Hash[query_array.each_slice(2).to_a]
      env['REQUEST_METHOD'] = method
      env['PATH_INFO'] = path
      env['VERSION'] = version
      env['QUERY_STRING'] = query
      until (line = socket.gets) == "\r\n" do
        header_values = line.split(":", 2)
        key = header_values[0]
        key = key.upcase.gsub("-", "_")
        unless key == 'CONTENT_TYPE' || key == 'CONTENT_LENGTH'
          key = "HTTP_#{key}"
        end
        value = header_values[1..-1].join.strip
        env[key] = value
      end
      body = socket.read(env["CONTENT_LENGTH"].to_i)
      env["BODY"] = body
      env
    end
  end

  def select(notes, selector)
    notes.select { |note| note =~ /#{selector}/i }
  end

  def select_all(notes, selectors)
    selectors.each { |selector| notes = select(notes, selector) }
    notes
  end

  def select_help(selector)
    selector
  end

  def select_integer(notes, selector)
    selector = /[0-9]/
    notes.select { |note| note =~ /#{selector}/ }
  end
end
