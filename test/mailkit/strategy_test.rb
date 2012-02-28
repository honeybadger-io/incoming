require 'test_helper'

class TestStrategy < ActiveSupport::TestCase
  test 'it instantiates a new object with arguments, authenticates, and calls #receive' do
    args = [1, 2, 3]
    
    object = mock()
    object.expects(:authenticate).once.returns(true)
    object.expects(:receive).once
    
    class Strategy
      include Mailkit::Strategy
    end
    
    Strategy.expects(:new).with(*args).returns(object)
    Strategy.receive(*args)
  end
end