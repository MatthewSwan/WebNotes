module Appmod
  App = Proc.new do |env_hash|
  path_info = env_hash['PATH_INFO']

  body1   = '<form action="/search.html" method="GET" accept-charset="utf-8">'             + "\n" +
            '<label for="query">Query:</label>'                                            + "\n" +
            '<input type="" name="query" value="" id="query">'                             + "\n" +
            '<p><input type="submit" value="Continue &rarr;"></p>'                         + "\n" +
            '</form>'

   body2   = "<HTML>
   <BODY>
   <P>Relevant Notes:</P>
  <ul>
    <li>yo due</li>
  </ul>
  <BODY>
  <HTML>"

   if path_info == "/"
     body = body1
   else
     body = body2
   end

     [200, {'Content-Type' => 'text/html', 'Content-Length' => body.length, 'omg' => 'bbq'}, [body]]
 end
end


