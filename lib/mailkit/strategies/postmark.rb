require 'postmark_mitt'

module Mailkit
  module Strategies
    class Postmark
      include Mailkit::Strategy

      def initialize(request)
        email = ::Postmark::Mitt.new(request.body.read)

        @to = email.to
        @from = email.from_email
        @subject = email.subject
        @body = email.text_body
        @attachments = email.attachments
      end
    end
  end
end