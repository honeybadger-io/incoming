require 'mail'

module Mailkit
  module Strategies
    class Raw
      include Mailkit::Strategy

      attr_accessor :signature, :token, :timestamp

      def initialize(raw_mail)
        mail = Mail.new(raw_mail)

        @to = mail.to.first
        @from = mail.from.first
        @subject = mail.subject

        if mail.multipart?
          @text = mail.text_part
          @html = mail.html_part
        else
          @text = mail.body.decoded
        end

        super
      end
    end
  end
end
