require 'json'
require 'base64'

module Incoming
  module Strategies
    class Postmark
      include Incoming::Strategy

      def initialize(request)
        source = JSON.parse(request.body.read)
        parsed_headers = parse_headers(source['Headers'])

        @message = Mail.new do
          headers parsed_headers

          body source['TextBody']

          html_part do
            content_type 'text/html; charset=UTF-8'
            body source['HtmlBody']
          end if source['HtmlBody']

          source['Attachments'].each do |a|
            add_file :filename => a['Name'], :content => Base64.decode64(a['Content'])
          end
        end
      end

      def parse_headers(source)
        source.inject({}){|hash,obj| hash[obj['Name']] = obj['Value']; hash}
      end
    end
  end
end
