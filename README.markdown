Mailkit Gem
-----------

Mailkit helps you receive email from several popular service providers
using various methods (mainly HTTP post hooks.)

## Sendgrid example:

```ruby
class EmailReceiver < Mailkit::Strategies::Sendgrid
  def receive
    puts %(Got message from #{to} with subject "#{subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

## Mailgun example:

```ruby
class EmailReceiver < Mailkit::Strategies::Mailgun
  setup api_key: 'asdf'

  def receive
    puts %(Got message from #{to} with subject "#{subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

## HTTP Post example:

```ruby
# mailkit-config.rb
Mailkit.setup do |config|
  config.http_post_secret = '6d7e5337a0cd69f52c3fcf9f5af438b1'
  config.http_post_endpoint = 'http://your-domain.com/emails'
end
```

```ruby
require_relative 'mailkit-config'

class EmailReceiver < Mailkit::Strategies::HTTPPost
  def receive
    puts %(Got message from #{to} with subject "#{subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

```
# Postfix virtual alias
mailkit_http_post: "|http_post -c /path/to/mailkit-config.rb"
```