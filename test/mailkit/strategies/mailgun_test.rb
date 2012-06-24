require 'test_helper'

describe Mailkit::Strategies::Mailgun do
  class MailReceiver < Mailkit::Strategies::Mailgun
    setup do |options|
      options.api_key = 'asdf'
    end

    def receive(mail)
    end
  end

  before do
    attachment = stub(:original_filename => 'hello.txt', :read => 'hello world')

    @params = {
      'recipient' => 'jack@example.com',
      'sender' => 'japhy@example.com',
      'from' => 'japhy@example.com',
      'subject' => 'Matterhorn',
      'body-plain' => 'We should do that again sometime.',
      'body-html' => '<strong>We should do that again sometime.</strong>',
      'signature' => 'foo',
      'message-headers' => '{}',
      'attachment-count' => '1',
      'attachment-1' => attachment
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(@params)
  end

  it 'it maps request parameters to correct attributes for non-mime request' do
    mailgun = MailReceiver.new(@mock_request)

    assert_kind_of Mail::Message, mailgun.message

    assert_equal @params['recipient'], mailgun.message.to[0]
    assert_equal @params['sender'], mailgun.message.from[0]
    assert_equal @params['subject'], mailgun.message.subject
    assert_equal @params['body-plain'], mailgun.message.body.decoded
    assert_equal @params['body-plain'], mailgun.message.text_part.body.decoded
    assert_equal @params['body-html'], mailgun.message.html_part.body.decoded
    assert_equal 'hello.txt', mailgun.message.attachments[0].filename
    assert_equal 'hello world', mailgun.message.attachments[0].read
  end

  it 'it returns false from #authenticate when hexidigest is invalid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('bar')

    mailgun = MailReceiver.new(@mock_request)
    assert mailgun.authenticate == false, 'should return false for invalid signature'
  end

  it 'returns true from #authenticate when hexidigest is valid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('foo')

    mailgun = MailReceiver.new(@mock_request)
    assert mailgun.authenticate == true, 'should return true for valid signature'
  end

  it 'raises an exception when api key is not provided' do
    MailReceiver.class_eval { setup({ :api_key => nil }) }

    assert_raises(Mailkit::Strategy::RequiredOptionError) do
      MailReceiver.new(@mock_request)
    end
  end
end
