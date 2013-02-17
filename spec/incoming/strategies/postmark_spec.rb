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
    subject { Incoming::Strategies::Postmark.new(@mock_request).message }

    it { should be_a Mail::Message }
    it { subject.to[0].should eq '451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com' }
    it { subject.from[0].should eq 'user@email.com' }
    it { subject.subject.should eq 'This is an inbound message' }
    it { subject.body.decoded.should eq '[ASCII]' }
    it { subject.attachments[0].filename.should eq 'hello.txt' }
    it { subject.attachments[0].read.should eq 'hello world' }
  end
end
