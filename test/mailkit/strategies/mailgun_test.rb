require 'test_helper'

describe Mailkit::Strategies::Mailgun do
  before do
    # TODO: use real mailgun post instead
    @params = {
      :recipient => 'jack@example.com',
      :sender => 'japhy@example.com',
      :from => 'japhy@example.com',
      :subject => 'Matterhorn',
      'body-plain' => 'We should do that again sometime.',
      :signature => 'foo',
      'message-headers' => '{}'
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(@params)
  end

  it 'it maps request parameters to correct attributes' do
    mailgun = Mailkit::Strategies::Mailgun.new(@mock_request)

    assert_equal @params[:recipient], mailgun.message.to[0]
    assert_equal @params[:sender], mailgun.message.from[0]
    assert_equal @params[:subject], mailgun.message.subject
    assert_equal @params['body-plain'], mailgun.message.body.decoded
  end

  it 'it returns false from #authenticate when hexidigest is invalid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('bar')

    mailgun = Mailkit::Strategies::Mailgun.new(@mock_request)
    assert mailgun.authenticate == false, 'should return false for invalid signature'
  end

  it 'returns true from #authenticate when hexidigest is valid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('foo')

    mailgun = Mailkit::Strategies::Mailgun.new(@mock_request)
    assert mailgun.authenticate == true, 'should return true for valid signature'
  end

end
