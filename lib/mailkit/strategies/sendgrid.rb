module Mailkit
  module Strategies
    class Sendgrid
      include Mailkit::Strategy

      def initialize(request)
        params = request.params
        envelope = JSON.parse(params[:envelope])

        @message = Mail.new do
          header params[:headers]
          from params[:from]
          to envelope['to'].first
          subject params[:subject]
          set_envelope envelope

          body params[:text]

          html_part do
            content_type 'text/html; charset=UTF-8'
            body params[:html]
          end if params[:html]
        end
      end
    end
  end
end
