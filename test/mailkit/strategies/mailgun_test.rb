require 'test_helper'

class TestMailgun < ActiveSupport::TestCase

  def setup
    @params = {
      :recipient => 'jack@example.com',
      :sender => 'japhy@example.com',
      :subject => 'Matterhorn',
      'body-plain' => 'We should do that again sometime.',
      :signature => 'foo'
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(@params)
  end

  test 'it maps request parameters to correct attributes' do
    mailgun = Mailkit::Strategies::Mailgun.new(@mock_request)

    assert_equal(@params[:recipient], mailgun.to)
    assert_equal(@params[:sender], mailgun.from)
    assert_equal(@params[:subject], mailgun.subject)
    assert_equal(@params['body-plain'], mailgun.body)
  end

  test 'it returns false from #authenticate when hexidigest is invalid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('bar')

    mailgun = Mailkit::Strategies::Mailgun.new(@mock_request)
    assert(mailgun.authenticate == false, 'should return false for invalid signature')
  end

  test 'returns true from #authenticate when hexidigest is valid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('foo')

    mailgun = Mailkit::Strategies::Mailgun.new(@mock_request)
    assert(mailgun.authenticate == true, 'should return true for valid signature')
  end

end