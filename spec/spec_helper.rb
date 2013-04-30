require 'rspec'
require 'incoming'

RSpec.configure do |c|
  c.mock_with :rspec
  c.color_enabled = true
  c.tty = true

  module Helpers
    def self.included(base)
      base.let(:receiver) { test_receiver }
    end

    def test_receiver(options = {})
      Class.new(described_class) do
        setup(options)

        def receive(mail)
          mail
        end
      end
    end
  end

  c.include Helpers
end
