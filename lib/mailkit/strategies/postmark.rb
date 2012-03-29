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
        @text = email.text_body
        @html = email.html_body
        @attachments = email.attachments

        super
      end
    end
  end
end
