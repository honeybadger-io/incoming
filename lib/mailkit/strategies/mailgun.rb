require 'json'

module Mailkit
  module Strategies
    # Public: MailGun Incoming Mail Strategy
    #
    # API Documentation:
    # http://documentation.mailgun.net/user_manual.html#receiving-messages
    #
    # Examples:
    #
    #   class MailReceiver < Mailkit::Strategies::Mailgun
    #     setup do |options|
    #       options.api_key = 'asdf'
    #     end
    #
    #     def receive(mail)
    #       puts "Got message from mailgun: #{mail.subject}"
    #     end
    #   end
    class Mailgun
      include Mailkit::Strategy

      attr_accessor :signature, :token, :timestamp

      def initialize(request)
        params = request.params

        if self.class.options.api_key.nil?
          raise RequiredOptionError.new(':api_key option is required.')
        end

        @signature = params['signature']
        @token = params['token']
        @timestamp = params['timestamp']

        @message = Mail.new do
          headers Hash[JSON.parse(params['message-headers'])]
          from params['from']
          to params['recipient']
          subject params['subject']

          body params['body-plain']

          html_part do
            content_type 'text/html; charset=UTF-8'
            body params['body-html']
          end if params['body-html']

          1.upto(params['attachment-count'].to_i).each do |num|
            attachment = params["attachment-#{num}"]
            add_file(:filename => attachment.original_filename, :content => attachment.read)
          end
        end
      end

      def authenticate
        api_key = self.class.options.api_key

        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA256'), api_key, [timestamp, token].join)
        hexdigest.eql?(signature) or false
      end

      protected

      def self.default_options
        {
          api_key: nil
        }.freeze
      end
    end
  end
end
