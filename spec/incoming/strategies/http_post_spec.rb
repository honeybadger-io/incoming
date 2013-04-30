require 'spec_helper'

describe Incoming::Strategies::HTTPPost do
  before do
    raw_email = File.open(File.expand_path("../../../fixtures/notification.eml",  __FILE__)).read

    params = {
      'signature' => 'foo',
      'message' => raw_email
    }

    @mock_request = mock()
    @mock_request.stub(:params).and_return(params)
  end

  describe 'message' do
    subject { receiver.receive(@mock_request) }
    before(:each) { OpenSSL::HMAC.stub(:hexdigest).and_return('foo') }

    it { should be_a Mail::Message }

    its('to.first') { should eq 'josh@joshuawood.net' }
    its('from.first') { should eq 'notifications@incoming.test' }
    its('subject') { should eq 'Jack Kerouac has replied to Test' }
    its('body.decoded') { should match /Reply ABOVE THIS LINE/ }
  end

  it 'returns false from #authenticate when hexidigest is invalid' do
    OpenSSL::HMAC.stub(:hexdigest).and_return('bar')
    http_post = Incoming::Strategies::HTTPPost.new(@mock_request)
    http_post.authenticate.should be_false
  end

  it 'returns true from #authenticate when hexidigest is valid' do
    OpenSSL::HMAC.stub(:hexdigest).and_return('foo')
    http_post = Incoming::Strategies::HTTPPost.new(@mock_request)
    http_post.authenticate.should be_true
  end
end
