require 'mailkit/engine'
require 'mailkit/strategy'
require 'mailkit/mailer'
require 'mailkit/strategies/raw'
require 'mailkit/strategies/http_post'
require 'mailkit/strategies/mailgun'
require 'mailkit/strategies/postmark'
require 'mailkit/strategies/sendgrid'

module Mailkit
  def self.config
    if block_given?
      @config = ActiveSupport::OrderedOptions.new.tap do |c|
        yield(c)
      end
    else
      @config
    end
  end
end
