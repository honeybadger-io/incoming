require 'json'

module Incoming
  module Strategies
    class Mandrill
      include Incoming::Strategy

      def self.receive(request)
        JSON.parse(request.params['mandrill_events']).map do |event|
          next unless event['event'] == 'inbound'
          result = super(event['msg'])
          yield(result) if block_given?
          result
        end.compact
      end

      def initialize(msg)
        @message = Mail.new(msg['raw_msg'])
      end
    end
  end
end
