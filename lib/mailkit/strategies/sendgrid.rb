module Mailkit
  module Strategies
    class Sendgrid
      include Mailkit::Strategy

      def initialize(request)
        params = request.params
        envelope = JSON.parse(params[:envelope])

        @to = envelope['to'].first
        @from = envelope['from']
        @subject = params[:subject]
        @body = params[:text]
        
        super
      end
    end
  end
end