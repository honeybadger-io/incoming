module Mailkit
  module Strategies
    class Sendgrid
      include Mailkit::Strategy

      def initialize(request)
        params = request.params
        envelope = JSON.parse(params[:envelope])

        @to = envelope['to'].first
        @from = params[:from]
        @subject = params[:subject]
        @text = params[:text]
        @html = params[:html]

        super
      end
    end
  end
end
