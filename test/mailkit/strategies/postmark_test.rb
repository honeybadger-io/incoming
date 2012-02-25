require 'test_helper'

class TestPostmark < ActiveSupport::TestCase

  def setup
    @raw_json = File.open(File.expand_path("../../../support/postmark_spec.json",  __FILE__)).read

    request_body = mock()
    request_body.expects(:read).returns(@raw_json)

    @mock_request = mock()
    @mock_request.expects(:body).returns(request_body)
  end

  test 'it parses request body as JSON and maps to correct attributes' do
    postmark = Mailkit::Strategies::Postmark.new(@mock_request)

    assert_equal('451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com', postmark.to)
    assert_equal('user@email.com', postmark.from)
    assert_equal('This is an inbound message', postmark.subject)
    assert_equal('[ASCII]', postmark.body)
  end

end