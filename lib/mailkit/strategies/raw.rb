module Mailkit
  module Strategies
    class Raw
      include Mailkit::Strategy

      def initialize(raw_mail)
        @message = Mail.new(raw_mail)
      end
    end
  end
end
