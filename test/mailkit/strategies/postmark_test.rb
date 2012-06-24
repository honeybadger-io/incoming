require 'test_helper'

describe Mailkit::Strategies::Postmark do
  before do
    @raw_json = File.read(File.expand_path("../../../support/postmark_spec.json",  __FILE__))

    request_body = mock()
    request_body.expects(:read).returns(@raw_json)

    @mock_request = mock()
    @mock_request.expects(:body).returns(request_body)
  end

  it 'parses request body as JSON and maps to correct attributes' do
    postmark = Mailkit::Strategies::Postmark.new(@mock_request)

    assert_kind_of Mail::Message, postmark.message

    assert_equal '451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com', postmark.message.to[0]
    assert_equal 'user@email.com', postmark.message.from[0]
    assert_equal 'This is an inbound message', postmark.message.subject
    assert_equal '[ASCII]', postmark.message.body.decoded
  end
end
