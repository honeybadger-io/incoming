require 'test_helper'

describe Mailkit::Strategy do
  class Strategy
    include Mailkit::Strategy
    option :api_key, nil
  end

  class MailReceiver < Strategy
    def receive(mail)
    end
  end

  describe 'self.setup with hash' do
    it 'raises an exception when invalid options have been set' do
      assert_raises(Mailkit::Strategy::InvalidOptionError) do
        MailReceiver.class_eval { setup({ :foo => 'invalid' }) }
      end
    end

    it 'raises no exception when valid options are set' do
      MailReceiver.class_eval { setup({ :api_key => 'valid' }) }
    end
  end

  describe 'self.receive' do
    it 'initializes itself and calls #receive' do
      args = [1, 2, 3]

      object = mock()
      object.expects(:authenticate).once.returns(true)
      object.expects(:message).once.returns('foo')
      object.expects(:receive).with('foo').once

      MailReceiver.expects(:new).with(*args).returns(object)
      MailReceiver.receive(*args)
    end
  end
end
