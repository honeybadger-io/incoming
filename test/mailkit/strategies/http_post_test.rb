require 'test_helper'

class TestHTTPPost < ActiveSupport::TestCase

  def setup
    raw_email = File.open(File.expand_path("../../../support/notification.eml",  __FILE__)).read

    params = {
      signature: 'foo',
      message: raw_email
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(params)
  end

  test 'it parses email to correct attributes' do
    http_post = Mailkit::Strategies::HTTPPost.new(@mock_request)

    assert_equal('josh@joshuawood.net', http_post.to)
    assert_equal('notifications@mailkit.test', http_post.from)
    assert_equal('Jack Kerouac has replied to Test', http_post.subject)
    assert(http_post.body =~ /Reply ABOVE THIS LINE/, 'Body should include reply instructions')
  end

  test 'returns false from #authenticate when hexidigest is invalid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('bar')

    http_post = Mailkit::Strategies::HTTPPost.new(@mock_request)
    assert(http_post.authenticate == false, 'should return false for invalid signature')
  end

  test 'does not return false from #authenticate when hexidigest is valid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('foo')

    http_post = Mailkit::Strategies::HTTPPost.new(@mock_request)
    assert(http_post.authenticate != false, 'should not return false for valid signature')
  end

end