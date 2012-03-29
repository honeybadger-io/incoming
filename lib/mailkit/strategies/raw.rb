module Mailkit
  module Strategies
    class Raw
      include Mailkit::Strategy

      attr_accessor :signature, :token, :timestamp

      def initialize(raw_mail)
        @message = Mail.new(raw_mail)
      end
    end
  end
end
