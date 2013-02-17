require 'mail'
require 'incoming/strategy'

module Incoming
  VERSION = '0.1.0'

  module Strategies
    autoload :Sendgrid, 'incoming/strategies/sendgrid'
    autoload :Mailgun, 'incoming/strategies/mailgun'
    autoload :Postmark, 'incoming/strategies/postmark'
    autoload :HTTPPost, 'incoming/strategies/http_post'
    autoload :Raw, 'incoming/strategies/raw'
  end
end
