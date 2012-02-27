require 'test_helper'

class TestStrategy < ActiveSupport::TestCase
  test 'it instantiates a new object with arguments, authenticates, and calls #receive' do
    args = [1, 2, 3]
    options = {foo: 'bar'}
    
    object = mock()
    object.expects(:authenticate).with(options).once.returns(true)
    object.expects(:receive).once
    
    Mailkit::Strategy.expects(:new).with(*args).returns(object)
    Mailkit::Strategy.receive(options, *args)
  end
end