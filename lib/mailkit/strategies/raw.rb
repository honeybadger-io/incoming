require 'mms2r'
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

        media = MMS2R::Media.new(mail)
        @body = media.body
      end
    end
  end
end