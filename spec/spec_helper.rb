require 'rspec'
require 'postmark_mitt'
require 'mailkit'

RSpec.configure do |c|
  c.mock_with :rspec
  c.color_enabled = true
  c.tty = true
end
