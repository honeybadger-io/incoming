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
        
        super
      end

      def authenticate
        api_key = self.class.options.api_key
        
        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA256'), api_key, [timestamp, token].join)
        hexdigest.eql?(signature) or false
      end
      
      protected
      def default_options
        {
          api_key: nil
        }
      end
    end
  end
end