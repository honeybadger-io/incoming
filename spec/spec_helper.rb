require 'rspec'
require 'incoming'
require 'rack'

RSpec.configure do |c|
  c.mock_with :rspec
  c.color_enabled = true
  c.tty = true

  module Helpers
    def self.included(base)
      base.let(:receiver) { test_receiver }
    end

    def recorded_requst(name)
      env = Marshal.load(File.read(File.join(File.expand_path('../../spec/fixtures/records', __FILE__), "#{name}.env")))
      env['rack.input'] = StringIO.new(env['rack.input'])
      Rack::Request.new(env)
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
