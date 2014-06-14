require 'json'

module Incoming
  module Strategies
    class SendGrid
      include Incoming::Strategy

      def initialize(request)
        params = request.params.dup

        encodings = JSON.parse(params['charsets'])

        attachments = 1.upto(params['attachments'].to_i).map do |num|
          attachment_from_params(params["attachment#{num}"])
        end

        @message = Mail.new do
          header params['headers']
          header['Content-Transfer-Encoding'] = nil

          if encodings['text'].blank?
            body params['text']
          else
            body params['text'].force_encoding(encodings['text']).encode('UTF-8')
          end

          html_part do
            content_type 'text/html; charset=UTF-8'
            if encodings['html'].blank?
              body params['html']
            else
              body params['html'].force_encoding(encodings['html']).encode('UTF-8')
            end
          end if params['html']

          attachments.each do |attachment|
            add_file(attachment)
          end
        end
      end
    end
  end
end
