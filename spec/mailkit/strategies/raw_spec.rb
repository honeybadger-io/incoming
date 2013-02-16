require 'spec_helper'

describe Mailkit::Strategies::Raw do
  before do
    @raw_email = File.open(File.expand_path("../../../fixtures/notification.eml",  __FILE__)).read
    @strategy = Mailkit::Strategies::Raw.new(@raw_email)
    @message = @strategy.message
  end

  describe 'message' do
    subject { @strategy.message }

    it { should be_a Mail::Message }
    it { subject.to[0].should eq 'josh@joshuawood.net' }
    it { subject.from[0].should eq 'notifications@mailkit.test' }
    it { subject.subject.should eq 'Jack Kerouac has replied to Test' }
    it { subject.body.decoded.should match /Reply ABOVE THIS LINE/ }
  end
end
