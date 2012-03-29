require 'test_helper'

class TestStrategy < MiniTest::Unit::TestCase
  class Strategy
    include Mailkit::Strategy
  end

  def test_receive
    args = [1, 2, 3]

    object = mock()
    object.expects(:authenticate).once.returns(true)
    object.expects(:message).once.returns('foo')
    object.expects(:receive).with('foo').once

    Strategy.expects(:new).with(*args).returns(object)
    Strategy.receive(*args)
  end
end
