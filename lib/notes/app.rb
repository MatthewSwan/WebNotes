require_relative 'server'
require 'erb'
module Appmod
  @notes = ['Add 1 to 2    1 + 2  # => 3',
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
            'Find out how big the array is    ["a","b"].length # => 2',
            'tip 1---- If a note includes your keyword the note will be returned!',
            'tip 2---- Narrow you search with multiple keywords']

  App = Proc.new do |env_hash|
    path_info = env_hash['PATH_INFO']

    @narrowed_notes = Select.new.select_all(@notes, env_hash['QUERY_STRING'])
    if @narrowed_notes == []
      @narrowed_notes = ["no matches found; please try again"]
    end

    if path_info == "/new.html"
      @notes.push(env_hash['QUERY_STRING'].pop)
      body = ERB.new(File.read('new.html')).result(binding)
    elsif path_info == "/"
      body = ERB.new(File.read('search.html')).result(binding)
    else
      body = ERB.new(File.read('results.html')).result(binding)
    end
    [200, {'Content-Type' => 'text/html', 'Content-Length' => body.length, 'omg' => 'bbq'}, [body]]
  end

  class Select
    def select(notes, selector)
      notes.select { |note| note =~ /#{selector}/i }
    end

    def select_all(notes, selectors)
      selectors.each { |selector| notes = select(notes, selector) }
      notes
    end
  end
end
