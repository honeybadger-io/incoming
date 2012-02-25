require 'test_helper'

class TestStrategy < ActiveSupport::TestCase
  test 'it instantiates a new object with arguments and calls #receive' do
    args = [1, 2, 3]
    object = stub(receive: true)
    object.expects(:receive).once
    Mailkit::Strategy.expects(:new).with(*args).returns(object)
    Mailkit::Strategy.receive(*args)
  end
end