require 'mms2r'

module Mailkit
  module Strategies
    class Raw
      include Mailkit::Strategy

      attr_accessor :signature, :token, :timestamp

      def initialize(mail)
        mail = Mailkit::Mailer.receive(mail)

        @to = mail.to.first
        @from = mail.from.first
        @subject = mail.subject

        media = MMS2R::Media.new(mail)
        @body = media.body
      end
    end
  end
end