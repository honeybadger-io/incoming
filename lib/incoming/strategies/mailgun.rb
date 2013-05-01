require 'json'

module Incoming
  module Strategies
    # Public: MailGun Incoming! Mail Strategy
    #
    # API Documentation:
    # http://documentation.mailgun.net/user_manual.html#receiving-messages
    #
    # Examples:
    #
    #   class MailReceiver < Incoming::Strategies::Mailgun
    #     setup api_key: 'asdf'
    #
    #     def receive(mail)
    #       puts "Got message from mailgun: #{mail.subject}"
    #     end
    #   end
    class Mailgun
      include Incoming::Strategy

      # Mailgun API key
      option :api_key

      # Use the stripped- parameters from the Mailgun API (strips out quoted parts and signatures)
      option :stripped, false

      attr_accessor :signature, :token, :timestamp

      def initialize(request)
        params = request.params

        if self.class.default_options[:api_key].nil?
          raise RequiredOptionError.new(':api_key option is required.')
        end

        @signature = params['signature']
        @token = params['token']
        @timestamp = params['timestamp']

        html_content = params[ self.class.default_options[:stripped] ? 'stripped-html' : 'body-html' ]
        text_content = params[ self.class.default_options[:stripped] ? 'stripped-text' : 'body-plain' ]

        attachments = 1.upto(params['attachment-count'].to_i).map do |num|
          attachment_from_params(params["attachment-#{num}"])
        end

        @message = Mail.new do
          headers Hash[JSON.parse(params['message-headers'])]
          from params['from']
          to params['recipient']
          subject params['subject']

          body text_content

          html_part do
            content_type 'text/html; charset=UTF-8'
            body html_content
          end if html_content

          attachments.each do |attachment|
            add_file(attachment)
          end
        end
      end

      def authenticate
        api_key = self.class.default_options[:api_key]

        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA256'), api_key, [timestamp, token].join)
        hexdigest.eql?(signature) or false
      end
    end
  end
end
