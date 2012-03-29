require 'test_helper'

describe Mailkit::Strategies::HTTPPost do
  before do
    raw_email = File.open(File.expand_path("../../../support/notification.eml",  __FILE__)).read

    params = {
      signature: 'foo',
      message: raw_email
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(params)
  end

  it 'it parses email to correct attributes' do
    http_post = Mailkit::Strategies::HTTPPost.new(@mock_request)

    assert_kind_of Mail::Message, http_post.message

    assert_equal 'josh@joshuawood.net', http_post.message.to[0]
    assert_equal 'notifications@mailkit.test', http_post.message.from[0]
    assert_equal 'Jack Kerouac has replied to Test', http_post.message.subject
    assert_match /Reply ABOVE THIS LINE/, http_post.message.body.decoded, 'Body should include reply instructions'
  end

  it 'returns false from #authenticate when hexidigest is invalid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('bar')

    http_post = Mailkit::Strategies::HTTPPost.new(@mock_request)
    assert http_post.authenticate == false, 'should return false for invalid signature'
  end

  it 'returns true from #authenticate when hexidigest is valid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('foo')

    http_post = Mailkit::Strategies::HTTPPost.new(@mock_request)
    assert http_post.authenticate == true, 'should return true for valid signature'
  end
end
