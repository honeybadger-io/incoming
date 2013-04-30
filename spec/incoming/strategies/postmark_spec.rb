require 'spec_helper'

describe Incoming::Strategies::Postmark do
  before do
    @raw_json = File.read(File.expand_path("../../../fixtures/postmark_spec.json",  __FILE__))

    request_body = stub()
    request_body.stub(:read).and_return(@raw_json)

    @mock_request = stub()
    @mock_request.stub(:body).and_return(request_body)
  end

  describe '#message' do
    subject { receiver.receive(@mock_request) }

    it { should be_a Mail::Message }

    its('to.first') { should eq '451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com' }
    its('from.first') { should eq 'user@email.com' }
    its('subject') { should eq 'This is an inbound message' }
    its('body.decoded') { should eq '[ASCII]' }
    its('attachments.first.filename') { should eq 'hello.txt' }
    its('attachments.first.read') { should eq 'hello world' }
  end
end
