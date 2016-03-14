require_relative '../lib/notes/web'
require 'net/http'

def port
  9292
end

app = Proc.new do |env_hash|
  path_info = env_hash['PATH_INFO']
  body    = '<form action="/search&query=array%20add" method="post" accept-charset="utf-8">'                  + "\n" +
            '<label for="query">Query:</label>'                                                               + "\n" +
            '<input type="text/submit/hidden/button" name="query" value="" id="query">'                       + "\n" +
            '<p><input type="submit" value="Continue &rarr;"></p>'                                            + "\n" +
            '</form>'
  [200, {'Content-Type' => 'text/plain', 'Content-Length' => body.length, 'omg' => 'bbq'}, [body]]
end

server = Notes::Web.new(app, Port: port, Host: 'localhost')
server.start
