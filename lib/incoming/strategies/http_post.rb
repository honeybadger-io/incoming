module Incoming
  module Strategies
    class HTTPPost
      include Incoming::Strategy

      option :secret

      attr_accessor :signature, :token, :timestamp

      def initialize(request)
        params = request.params

        @signature = params['signature']
        @token = params['token']
        @timestamp = params['timestamp']
        @message = Mail.new(params['message'])
      end

      def authenticate
        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA256'), self.class.default_options[:secret], [timestamp, token].join)
        hexdigest.eql?(signature) or false
      end
    end
  end
end
