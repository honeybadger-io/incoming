module Mailkit
  module Strategies
    class Sendgrid
      include Mailkit::Strategy

      def initialize(request)
        params = request.params.dup
        envelope = JSON.parse(params['envelope'])
        encodings = JSON.parse(params['charsets'])

        encodings.each_pair do |key, encoding|
          params[key].encode!('UTF-8', encoding, invalid: :replace, undef: :replace)
        end

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
            add_file :filename => attachment.original_filename, :content => attachment.read
          end
        end
      end
    end
  end
end
