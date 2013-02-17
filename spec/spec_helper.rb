require 'rspec'
require 'incoming'

RSpec.configure do |c|
  c.mock_with :rspec
  c.color_enabled = true
  c.tty = true
end
