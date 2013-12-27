require 'json'
require 'base64'

module Incoming
  module Strategies
    class Postmark
      include Incoming::Strategy

      def initialize(request)
        source = JSON.parse(request.body.read)

        headers = parse_headers(source['Headers'])
        from    = parse_address(source['FromFull'])
        to      = source['ToFull'].map{|h| parse_address(h)}
        cc      = source['CcFull'].map{|h| parse_address(h)}

        @message = Mail.new do
          headers   headers
          from      from
          to        to
          cc        cc
          reply_to  source['ReplyTo']
          subject   source['Subject']
          date      source['Date']

          body source['TextBody']

          html_part do
            content_type 'text/html; charset=UTF-8'
            body CGI.unescapeHTML(source['HtmlBody'])
          end if source['HtmlBody']

          source['Attachments'].each do |a|
            add_file :filename => a['Name'], :content => Base64.decode64(a['Content'])
          end

          %w(MailboxHash MessageID Tag).each do |key|
            if source[key] =~ /\S/
              header[key] = source[key]
            end
          end
        end
      end

      private

        def parse_headers(source)
          source.inject({}){|hash,obj| hash[obj['Name']] = obj['Value']; hash}
        end

        def parse_address(hash)
          Mail::Address.new(hash['Email']).tap do |address|
            address.display_name = hash['Name']
          end.to_s
        end
    end
  end
end
