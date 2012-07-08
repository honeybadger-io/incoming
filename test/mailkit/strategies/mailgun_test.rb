require 'test_helper'

describe Mailkit::Strategies::Mailgun do
  class MailgunReceiver < Mailkit::Strategies::Mailgun
    def receive(mail)
      'success'
    end
  end

  before do
    attachment = stub(:original_filename => 'hello.txt', :read => 'hello world')

    @params = {
      'recipient' => 'jack@example.com',
      'sender' => 'japhy@example.com',
      'from' => 'japhy@example.com',
      'subject' => 'Matterhorn',
      'body-plain' => "We should do that again sometime.\n> Quoted part",
      'body-html' => '<strong>We should do that again sometime.</strong>\r\n> <em>Quoted part</em>',
      'stripped-text' => 'We should do that again sometime.',
      'stripped-html' => '<strong>We should do that again sometime.</strong>',
      'signature' => 'foo',
      'message-headers' => '{}',
      'attachment-count' => '1',
      'attachment-1' => attachment
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(@params)

    MailgunReceiver.class_eval do
      setup :api_key => 'asdf'
    end
  end

  describe 'non-mime request' do
    it 'maps request parameters to correct attributes' do
      mailgun = MailgunReceiver.new(@mock_request)

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

    describe 'stripped option is true' do
      before do
        MailgunReceiver.class_eval do
          setup :api_key => 'asdf', :stripped => true
        end
      end

      it 'uses stripped options' do
        mailgun = MailgunReceiver.new(@mock_request)

        assert_kind_of Mail::Message, mailgun.message

        assert_equal @params['stripped-text'], mailgun.message.body.decoded
        assert_equal @params['stripped-text'], mailgun.message.text_part.body.decoded
        assert_equal @params['stripped-html'], mailgun.message.html_part.body.decoded
      end
    end
  end

  it 'it fails authentication when hexidigest is invalid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('bar')

    mailgun = MailgunReceiver.receive(@mock_request)
    assert_equal false, mailgun
  end

  it 'authenticates when hexidigest is valid' do
    OpenSSL::HMAC.expects(:hexdigest).returns('foo')

    mailgun = MailgunReceiver.receive(@mock_request)
    assert_equal 'success', mailgun
  end

  it 'raises an exception when api key is not provided' do
    MailgunReceiver.class_eval { setup({ :api_key => nil }) }

    assert_raises(Mailkit::Strategy::RequiredOptionError) do
      MailgunReceiver.new(@mock_request)
    end
  end
end
