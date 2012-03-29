require 'test_helper'

describe Mailkit::Strategies::Raw do
  before do
    @raw_email = File.open(File.expand_path("../../../support/notification.eml",  __FILE__)).read
    @strategy = Mailkit::Strategies::Raw.new(@raw_email)
    @message = @strategy.message
  end

  it 'assigns a Mail::Message to #message' do
    assert_kind_of Mail::Message, @message
  end

  it 'parses email to correct attributes' do
    assert_equal 'josh@joshuawood.net', @message.to[0]
    assert_equal 'notifications@mailkit.test', @message.from[0]
    assert_equal 'Jack Kerouac has replied to Test', @message.subject
    assert_match /Reply ABOVE THIS LINE/, @message.body.decoded
  end
end
