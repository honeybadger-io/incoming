require 'mail'
require 'incoming/strategy'

module Incoming
  VERSION = '0.1.7'

  module Strategies
    autoload :Mandrill, 'incoming/strategies/mandrill'
    autoload :SendGrid, 'incoming/strategies/sendgrid'
    autoload :Mailgun, 'incoming/strategies/mailgun'
    autoload :Postmark, 'incoming/strategies/postmark'
    autoload :CloudMailin, 'incoming/strategies/cloudmailin'
    autoload :HTTPPost, 'incoming/strategies/http_post'
  end
end
