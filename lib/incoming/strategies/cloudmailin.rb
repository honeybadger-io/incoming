module Incoming
  module Strategies
    class CloudMailin
      include Incoming::Strategy

      def initialize(request)
        @message = Mail.new(request.params.delete(:message))
      end
    end
  end
end

