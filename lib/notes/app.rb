require_relative 'web'
module Appmod
  App = Proc.new do |env_hash|
  path_info = env_hash['PATH_INFO']
  notes = ['Add 1 to 2    1 + 2  # => 3',
        'Subtract 5 from 2    2 - 5  # => -3',
        'Is 1 less than 2    1 < 2  # => true',
        'Is 1 equal to 2    1 == 2 # => 3',
        'Is 1 greater than 2    1 > 2  # => 3',
        'Is 1 less than or equal to 2    1 <= 2 # => 3',
        'Is 1 greater than or equal to 2    1 >= 2 # => 3',
        'Convert 1 to a float    1.to_f # => 3',
        'Concatenate two arrays    [1,2] + [2, 3]   # => [1, 2, 2, 3]',
        'Remove elements in second array from first    [1,2,4] - [2, 3] # => [1,4]',
        'Access an element in an array by its index    ["a","b","c"][0] # => "a"',
        'Find out how big the array is    ["a","b"].length # => 2']



  body1   = '<form action="/search.html" method="GET" accept-charset="utf-8">'             + "\n" +
            '<label for="query">Query:</label>'                                            + "\n" +
            '<input type="" name="query" value="" id="query">'                             + "\n" +
            '<p><input type="submit" value="Continue &rarr;"></p>'                         + "\n" +
            '</form>'

  narrowed_notes = Select.new.select_all(notes, env_hash['QUERY_STRING'])
  narrowed_notes.map! {|x| "<li>" + x + "<li>" }


   body2   = "<HTML>
   <BODY>
   <P>Relevant Notes:</P>
  <ul>
    #{narrowed_notes.join}
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

  class Select
    def select(notes, selector)
        notes.select { |note| note =~ /#{selector}/i }
      end

      def select_all(notes, selectors )
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

end
