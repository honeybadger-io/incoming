module Incoming
  module Strategies
    class Raw
      include Incoming::Strategy

      def initialize(raw_mail)
        @message = Mail.new(raw_mail)
      end
    end
  end
end
