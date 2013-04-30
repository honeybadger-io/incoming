require 'json'

module Incoming
  module Strategies
    class SendGrid
      include Incoming::Strategy

      def initialize(request)
        params = request.params.dup
        envelope = JSON.parse(params['envelope'])

        # TODO: Properly handle encodings
        # encodings = JSON.parse(params['charsets'])

        @message = Mail.new do
          header params['headers']
          from params['from']
          to envelope['to'].first
          subject params['subject']

          body params['text']

          html_part do
            content_type 'text/html; charset=UTF-8'
            body params['html']
          end if params['html']

          1.upto(params['attachments'].to_i).each do |num|
            attachment = params["attachment#{num}"]
            add_file(:filename => attachment.original_filename, :content => attachment.read)
          end
        end
      end
    end
  end
end
