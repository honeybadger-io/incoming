require 'spec_helper'

describe Incoming::Strategies::Sendgrid do
  before do
    attachment = stub(:original_filename => 'hello.txt', :read => 'hello world')

    @params = {
      'SPF' => 'pass',
      'charsets' => '{"from": "UTF-8", "subject": "UTF-8", "text": "ISO-8859-1", "to": "UTF-8"}',
      'dkim' => 'none',
      'envelope' => JSON.generate({
        'to' => ['jack@example.com'],
        'from' => 'japhy@example.com'
      }),
      'from' => 'Japhy Ryder <japhy@example.com>',
      'headers' => '',
      'subject' => 'Matterhorn',
      'text' => 'We should do that again sometime.',
      'html' => '<strong>We should do that again sometime</strong>',
      'to' => 'jack@example.com',
      'attachments' => '1',
      'attachment1' => attachment
    }

    @mock_request = stub()
    @mock_request.stub(:params).and_return(@params)
  end

  describe 'message' do
    subject { Incoming::Strategies::Sendgrid.new(@mock_request).message }

    it { should be_a Mail::Message }
    it { subject.to[0].should eq 'jack@example.com' }
    it { subject.from[0].should eq 'japhy@example.com' }
    it { subject.subject.should eq @params['subject'] }
    it { subject.body.decoded.should eq @params['text'] }
    it { subject.text_part.body.decoded.should eq @params['text'] }
    it { subject.html_part.body.decoded.should eq @params['html'] }
    it { subject.attachments[0].filename.should eq 'hello.txt' }
    it { subject.attachments[0].read.should eq 'hello world' }
  end
end
