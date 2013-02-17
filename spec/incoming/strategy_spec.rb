require 'spec_helper'

describe Incoming::Strategy do
  class Strategy
    include Incoming::Strategy
    option :api_key, nil
  end

  class MailReceiver < Strategy
    def receive(mail)
    end
  end

  describe 'self.setup with hash' do
    it 'raises an exception when invalid options have been set' do
      expect {
        MailReceiver.class_eval { setup({ :foo => 'invalid' }) }
      }.to raise_error(Incoming::Strategy::InvalidOptionError)
    end

    it 'raises no exception when valid options are set' do
      expect {
        MailReceiver.class_eval { setup({ :api_key => 'valid' }) }
      }.to_not raise_error
    end
  end

  describe 'self.receive' do
    it 'initializes itself and calls #receive' do
      args = [1, 2, 3]

      object = stub()
      object.stub(:authenticate).once.and_return(true)
      object.stub(:message).once.and_return('foo')
      object.stub(:receive).with('foo').once

      MailReceiver.should_receive(:new).with(*args).and_return(object)
      MailReceiver.receive(*args)
    end
  end
end
