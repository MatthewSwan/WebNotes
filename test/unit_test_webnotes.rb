require 'notes/web'

class ParserUnitTest < Minitest::Test
  attr_reader :env
  def setup
    @read, @write = IO.pipe
    @write.print "POST /somepath HTTP/1.1\r\n"
    @write.print "Location: http://www.google.com/\r\n"
    @write.print "Content-Type: text/html; charset=UTF-8\r\n"
    @write.print "Date: Wed, 02 Mar 2016 01:09:43 GMT\r\n"
    @write.print "Expires: Fri, 01 Apr 2016 01:09:43 GMT\r\n"
    @write.print "Cache-Control: public, max-age=2592000\r\n"
    @write.print "Server: gws\r\n"
    @write.print "Content-Length: 9\r\n"
    @write.print "X-XSS-Protection: 1; mode=block\r\n"
    @write.print "X-Frame-Options: SAMEORIGIN\r\n"
    @write.print "\r\n"
    @write.print "some body"

    @env = Notes::Web.parser(@read)
  end

  def teardown
    @write.close
    @read.close
  end

  def test_it_parses_first_token_into_REQUEST_METHOD
    assert_equal env['REQUEST_METHOD'], 'POST'
  end

  def test_it_parses_second_token_into_PATH
    assert_equal env['PATH_INFO'], '/somepath'
  end

  def test_it_parses_third_token_into_VERSION
    assert_equal env['VERSION'], 'HTTP/1.1'
  end

  def test_it_parses_header_values_into_key_value_pairs
    assert_equal env["HTTP_X_FRAME_OPTIONS"], "SAMEORIGIN"
  end

  def test_it_prepends_header_values_with_HTTP
    assert_equal env["HTTP_SERVER"], "gws"
  end

  def test_it_parses_a_string_with_multiple_colons
    assert_equal env["HTTP_DATE"], "Wed, 02 Mar 2016 01:09:43 GMT"
  end

  def test_it_does_not_prepend_content_length_and_type_with_HTTP
    assert_equal env["CONTENT_LENGTH"], "9"
    assert_equal env["CONTENT_TYPE"], "text/html; charset=UTF-8"
  end

  def test_it_parses_body_string_into_key_value_pair
    assert_equal env["BODY"], "some body"
  end
end



class PrinterUnitTest < Minitest::Test
  attr_reader :env
  def setup
    @read, @write = IO.pipe
    #@write.print "POST /somepath HTTP/1.1\r\n"
    #@write.print "Location: http://www.google.com/\r\n"
    #@write.print "Content-Type: text/html; charset=UTF-8\r\n"
    #@write.print "Date: Wed, 02 Mar 2016 01:09:43 GMT\r\n"
    #@write.print "Expires: Fri, 01 Apr 2016 01:09:43 GMT\r\n"
    #@write.print "Cache-Control: public, max-age=2592000\r\n"
    #@write.print "Server: gws\r\n"
    #@write.print "Content-Length: 9\r\n"
    #@write.print "X-XSS-Protection: 1; mode=block\r\n"
    #@write.print "X-Frame-Options: SAMEORIGIN\r\n"
    #@write.print "\r\n"
    #@write.print "some body"

    @env = Notes::Web.printer(@write, 200, {'Content-Type' => 'text/plain', 'Content-Length' => 4, 'omg' => 'bbq'}, ["yeah", "green"] )
  end

  def teardown
    @write.close
    @read.close
  end

  def test_it_prints_the_shit
    @write.close
    assert_equal @read.read, "HTTP/1.1 200 some text goes here *shrug*\r\nContent-Type: text/plain\r\nContent-Length: 4\r\nomg: bbq\r\n\r\nyeahgreen"
  end
end

