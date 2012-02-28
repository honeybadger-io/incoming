require 'ostruct'
require 'mailkit/strategy'
require 'mailkit/strategies/raw'
require 'mailkit/strategies/http_post'
require 'mailkit/strategies/mailgun'
require 'mailkit/strategies/postmark'
require 'mailkit/strategies/sendgrid'

module Mailkit
  def self.setup
    yield(config)
  end

  def self.config
    @config ||= OpenStruct.new(default_config)
  end

  protected
  def self.default_config
    {
      http_post_secret: nil,
      http_post_endpoint: nil
    }
  end
end
