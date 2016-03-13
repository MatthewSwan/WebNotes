require 'rack'

app = Proc.new do |env|
  status  = 200
  headers = {'Content-Type' => 'text/html'}
  body    = '<form action="/search" method="post" accept-charset="utf-8">'                                    + "\n" +
            '<label for="query">Query:</label>'                                                               + "\n" +
            '<input type="text/submit/hidden/button" name="query" value="" id="query">'                       + "\n" +
            '<p><input type="submit" value="Continue &rarr;"></p>'                                            + "\n" +
            '</form>'


  headers['Content-Length'] = body.length.to_s
  [status, headers, body.lines]
end


Rack::Handler.default.run app, Port: 4300, Host: 'localhost'

#Now that you can serve rack apps, make an app that returns a body with an HTML form in it. It has one field, named "query".
# When submitted, it makes a GET request to "/search", with the query embedded in the path like this: /search&query=array%20add.
#Place the query string in the env hash at the key QUERY_STRING.
#You don't need to make a web request to unit test this, your server parses the web request into a hash, so you can test your app
#by calling it with the same hash.
#
#To unit test this, just give it a hash like your server would have created. Again, you can play with exploring_rack.rb to see
#how other servers have done this.







