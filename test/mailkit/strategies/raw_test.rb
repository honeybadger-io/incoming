require 'test_helper'

class TestRaw < ActiveSupport::TestCase

  def setup
    @raw_email = File.open(File.expand_path("../../../support/notification.eml",  __FILE__)).read
  end

  test 'parses email to correct attributes' do
    raw = Mailkit::Strategies::Raw.new(@raw_email)

    assert_equal('josh@joshuawood.net', raw.to)
    assert_equal('notifications@mailkit.test', raw.from)
    assert_equal('Jack Kerouac has replied to Test', raw.subject)
    assert(raw.body =~ /Reply ABOVE THIS LINE/, 'Body should include reply instructions')
  end

end