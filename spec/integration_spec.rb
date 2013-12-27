require 'spec_helper'

describe Incoming::Strategies::Mailgun do
  let(:receiver) { test_receiver(:api_key => 'asdf') }

  describe 'end-to-end' do
    let(:request) { recorded_request('mailgun') }
    before { OpenSSL::HMAC.stub(:hexdigest).and_return(request.params['signature']) }

    it 'receives the request' do
      expect(receiver.receive(request)).to be_a Mail::Message
    end
  end
end

describe Incoming::Strategies::Postmark do
  let(:receiver) { test_receiver }

  describe 'end-to-end' do
    let(:request) { recorded_request('postmark') }

    it 'receives the request' do
      expect(receiver.receive(request)).to be_a Mail::Message
    end
  end
end
