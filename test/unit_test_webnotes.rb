require 'notes/web'

class UnitTest < Minitest::Test
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
  end

  def teardown
    @write.close
    @read.close
  end

  def test_it_parses_first_token_into_REQUEST_METHOD
    setup
    env = Notes::Web.parser(@read)
    assert_equal (env['REQUEST_METHOD']), 'POST'
    teardown
  end

  def test_it_parses_second_token_into_PATH
    setup
    env = Notes::Web.parser(@read)
    assert_equal (env['PATH']), '/somepath'
    teardown
  end

  def test_it_parses_third_token_into_VERSION
    setup
    env = Notes::Web.parser(@read)
    assert_equal (env['VERSION']), 'HTTP/1.1'
    teardown
  end

  def test_it_parses_header_values_into_key_value_pairs
    setup
    env = Notes::Web.parser(@read)
    assert_equal (env["Server"]), "gws"
    teardown
  end
end
