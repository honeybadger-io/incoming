Mailkit
-----------

Mailkit helps you receive email in your Rack apps.

Brought to you by :zap: **Honeybadger.io**, painless [Rails exception tracking](https://www.honeybadger.io/).

## Sendgrid example:

```ruby
class EmailReceiver < Mailkit::Strategies::Sendgrid
  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

## Mailgun example:

```ruby
class EmailReceiver < Mailkit::Strategies::Mailgun
  setup api_key: 'asdf'

  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

## Postmark example:

```ruby
class EmailReceiver < Mailkit::Strategies::Postmark
  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

## HTTP Post example:

```ruby
class EmailReceiver < Mailkit::Strategies::HTTPPost
  setup secret: '6d7e5337a0cd69f52c3fcf9f5af438b1'

  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

```
# Postfix virtual alias
http_post: "|http_post -s 6d7e5337a0cd69f52c3fcf9f5af438b1 http://www.example.com/emails"
```

## Contributing

1. Fork it.
2. Create a topic branch `git checkout -b my_branch`
3. Commit your changes `git commit -am "Boom"`
3. Push to your branch `git push origin my_branch`
4. Send a [pull request](https://github.com/honeybadger-io/mailkit/pulls)

## License

Mailkit is Copyright 2013 © Honeybadger Industries LLC. It is free software, and
may be redistributed under the terms specified in the MIT-LICENSE file.
