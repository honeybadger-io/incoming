module Mailkit
  module Strategies
    class HTTPPost < Raw
      attr_accessor :signature, :token, :timestamp

      def initialize(request)
        params = request.params

        @signature = params.delete(:signature)
        @token = params.delete(:token)
        @timestamp = params.delete(:timestamp)

        super(params.delete(:message))
      end

      def authenticate(options = {})
        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA256'), Mailkit.config.secret, [timestamp, token].join)
        hexdigest.eql?(signature) or return false
      end
    end
  end
end