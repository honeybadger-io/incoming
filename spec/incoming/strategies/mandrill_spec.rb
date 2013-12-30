require 'spec_helper'

describe Incoming::Strategies::Mandrill do
  let(:request) { recorded_request('mandrill') }

  describe '.receive' do
    it 'returns an Array of results from each message' do
      result = receiver.receive(request)
      expect(result).to be_a Array
      expect(result.map { |r| r.class }).to eq [Mail::Message, Mail::Message]
    end

    it 'skips non-inbound events' do
      mandrill_events = JSON.parse(request.params['mandrill_events'])
      mandrill_events << {'event' => 'other'}
      request.params['mandrill_events'] = mandrill_events.to_json
      expect(receiver.receive(request).size).to eq 2
    end

    context 'with a block' do
      specify { expect { |b| receiver.receive(request, &b) }.to yield_successive_args(Mail::Message, Mail::Message) }
    end
  end

  describe 'message' do
    subject { receiver.receive(request).first }

    it { should be_a Mail::Message }

    its('to') { should include 'testing@inbound.honeybadger.io' }
    its('from') { should include 'example.sender@mandrillapp.com' }
    its('subject') { should eq 'This is an example webhook message' }
    its('text_part.body.decoded') { should eq 'This is an example inbound message.' }
    its('html_part.body.decoded') { should match /<p>This is an example inbound message\.<\/p>/ }
  end
end
