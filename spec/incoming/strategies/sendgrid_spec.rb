require 'spec_helper'

describe Incoming::Strategies::SendGrid do
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
    subject { receiver.receive(@mock_request) }

    it { should be_a Mail::Message }

    its('to.first') { should eq 'jack@example.com' }
    its('from.first') { should eq 'japhy@example.com' }
    its('subject') { should eq @params['subject'] }
    its('body.decoded') { should eq @params['text'] }
    its('text_part.body.decoded') { should eq @params['text'] }
    its('html_part.body.decoded') { should eq @params['html'] }
    its('attachments.first.filename') { should eq 'hello.txt' }
    its('attachments.first.read') { should eq 'hello world' }
  end
end
