module Mailkit
  module Strategies
    class Mailgun
      include Mailkit::Strategy

      attr_accessor :signature, :token, :timestamp

      def initialize(request)
        params = request.params

        @to = params[:recipient]
        @from = params[:sender]
        @subject = params[:subject]
        @body = params['body-plain']
        @signature = params[:signature]
        @token = params[:token]
        @timestamp = params[:timestamp]
      end

      def receive
        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA256'), Mailkit.config.api_key, [timestamp, token].join)
        return false unless hexdigest.eql?(signature)
        super
      end
    end
  end
end