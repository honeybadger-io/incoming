require 'spec_helper'

describe Incoming::Strategies::CloudMailin do
  before do
    raw_email = File.open(File.expand_path("../../../fixtures/notification.eml",  __FILE__)).read

    params = {
      :message => raw_email,
      :envelope => {
        "to" => "asdf@cloudmailin.net",
        "from" => "josh@joshuawood.net",
        "helo_domain" => "mail-da0-f41.google.com",
        "remote_ip" => "127.0.0.1",
        "spf" => {
          "result" => "pass",
          "domain" => "joshuawood.net"
        }
      }
    }

    @mock_request = mock()
    @mock_request.stub(:params).and_return(params)
  end

  describe 'message' do
    subject { Incoming::Strategies::CloudMailin.new(@mock_request).message }

    it { subject.should be_a Mail::Message }
    it { subject.to[0].should eq 'josh@joshuawood.net' }
    it { subject.from[0].should eq 'notifications@incoming.test' }
    it { subject.subject.should eq 'Jack Kerouac has replied to Test' }
    it { subject.body.decoded.should match /Reply ABOVE THIS LINE/ }
  end
end

