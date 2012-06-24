module Mailkit
  module Strategies
    class HTTPPost < Raw
      option :http_post_secret

      attr_accessor :signature, :token, :timestamp

      def initialize(request)
        params = request.params

        @signature = params.delete(:signature)
        @token = params.delete(:token)
        @timestamp = params.delete(:timestamp)

        super(params.delete(:message))
      end

      def authenticate
        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA256'), self.class.default_options[:http_post_secret], [timestamp, token].join)
        hexdigest.eql?(signature) or false
      end
    end
  end
end
