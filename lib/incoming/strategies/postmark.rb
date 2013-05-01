require 'postmark_mitt'
require 'base64'

module Incoming
  module Strategies
    class Postmark
      include Incoming::Strategy

      def initialize(request)
        email = ::Postmark::Mitt.new(request.body.read)

        @attachments = email.attachments

        @message = Mail.new do
          headers email.headers

          body email.text_body

          html_part do
            content_type 'text/html; charset=UTF-8'
            body email.html_body
          end if email.html_body

          email.attachments.each do |a|
            add_file :filename => a.file_name, :content => Base64.decode64(a.source['Content'])
          end
        end
      end
    end
  end
end
