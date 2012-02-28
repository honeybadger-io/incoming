Mailkit Gem
-----------

Mailkit helps you receive email from several popular service providers
using various methods (mainly HTTP post hooks.)

## Sendgrid:

```ruby
class EmailReceiver < Mailkit::Strategies::Sendgrid
  def receive
    puts %(Got message from #{to} with subject "#{subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

```ruby
class EmailReceiver < Mailkit::Strategies::Mailgun
  default_options api_key: 'asdf'

  def receive
    puts %(Got message from #{to} with subject "#{subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```