require 'spec_helper'

describe Incoming::Strategies::Postmark do
  let(:request) { recorded_request('postmark') }

  context 'json parse error' do
    it 'raises exception to caller' do
      request.stub_chain(:body, :read).and_return('{invalid')
      expect { receiver.receive(request) }.to raise_error(JSON::ParserError)
    end
  end

  describe '#message' do
    subject { receiver.receive(request) }

    it { should be_a Mail::Message }

    specify { expect(subject.header['MailboxHash']).to be_nil }
    specify { expect(subject.header['MessageID']).not_to be_nil }
    specify { expect(subject.header['Tag']).to be_nil }

    %w(MailboxHash Tag).each do |header|
      it "includes #{header} header when present" do
        parsed_json = JSON.parse(request.body.read)
        parsed_json[header] = 'asdf'
        JSON.stub(:parse).and_return(parsed_json)
        expect(subject.header[header]).not_to be_nil
      end
    end

    its('to') { should include '9cebd9cfe7e7a96f140d0accbd187b42@inbound.postmarkapp.com' }
    its('cc') { should include 'josh+incoming@honeybadger.io' }
    its('from') { should include 'josh@honeybadger.io' }
    its('subject') { should eq 'Test subject' }
    its('body.decoded') { should match 'Test body' }
    its('html_part.body.decoded') { should match 'Test body' }
    its('html_part.body.decoded') { should_not match '&lt;' }
    its('html_part.body.decoded') { should match '<' }
    its('attachments.first.filename') { should eq 'hello.txt' }
    its('attachments.first.read') { should match 'hello world' }
    its('attachments.last.filename') { should eq 'hullo.txt' }
    its('attachments.last.read') { should match 'hullo world' }
  end
end
