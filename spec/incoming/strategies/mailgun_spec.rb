require 'spec_helper'

describe Incoming::Strategies::Mailgun do
  class MailgunReceiver < Incoming::Strategies::Mailgun
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

    @mock_request = stub()
    @mock_request.stub(:params).and_return(@params)

    MailgunReceiver.class_eval do
      setup :api_key => 'asdf'
    end
  end

  describe 'non-mime request' do
    describe 'message' do
      subject { MailgunReceiver.new(@mock_request).message }

       it { subject.should be_a Mail::Message }

       it { subject.to[0].should eq @params['recipient'] }
       it { subject.from[0].should eq @params['sender'] }
       it { subject.subject.should eq @params['subject'] }
       it { subject.body.decoded.should eq @params['body-plain'] }
       it { subject.text_part.body.decoded.should eq @params['body-plain'] }
       it { subject.html_part.body.decoded.should eq @params['body-html'] }
       it { subject.attachments[0].filename.should eq 'hello.txt' }
       it { subject.attachments[0].read.should eq 'hello world' }

      context 'stripped option is true' do
        before do
          MailgunReceiver.class_eval do
            setup :api_key => 'asdf', :stripped => true
          end
        end

        it { subject.should be_a Mail::Message }
        it { subject.body.decoded.should eq @params['stripped-text'] }
        it { subject.text_part.body.decoded.should eq @params['stripped-text'] }
        it { subject.html_part.body.decoded.should eq @params['stripped-html'] }
      end
    end
  end

  it 'it fails authentication when hexidigest is invalid' do
    OpenSSL::HMAC.stub(:hexdigest).and_return('bar')
    mailgun = MailgunReceiver.receive(@mock_request)
     mailgun.should be_false
  end

  it 'authenticates when hexidigest is valid' do
    OpenSSL::HMAC.stub(:hexdigest).and_return('foo')
    mailgun = MailgunReceiver.receive(@mock_request)
    mailgun.should eq 'success'
  end

  it 'raises an exception when api key is not provided' do
    MailgunReceiver.class_eval { setup({ :api_key => nil }) }

    expect {
      MailgunReceiver.new(@mock_request)
    }.to raise_error Incoming::Strategy::RequiredOptionError
  end
end
