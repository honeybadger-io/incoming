Incoming!
-----------

### Receive email in your Rack apps.

Incoming! receives a `Rack::Request` and hands you a [`Mail::Message`](https://github.com/mikel/mail/), much
like `ActionMailer::Base.receive` does with a raw email. We currently
support the following services:

* SendGrid
* Mailgun
* Postmark
* CloudMailin
* Mandrill
* Any mail server capable of routing messages to a system command

Brought to you by :zap: **Honeybadger.io**, painless [Rails exception tracking](https://www.honeybadger.io/).

[![Build Status](https://travis-ci.org/honeybadger-io/incoming.png)](https://travis-ci.org/honeybadger-io/incoming)
[![Gem Version](https://badge.fury.io/rb/incoming.png)](http://badge.fury.io/rb/incoming)

## Installation

1. Add Incoming! to your Gemfile and run `bundle install`:

    ```ruby
    gem "incoming"
    ```

2. Create a new class to receive emails (see examples below)

3. Implement an HTTP endpoint to receive HTTP post hooks, and pass the
   request to your receiver. (see examples below)

## SendGrid Example

```ruby
class EmailReceiver < Incoming::Strategies::SendGrid
  def receive(mail)
    %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[Sendgrid API reference](http://sendgrid.com/docs/API_Reference/Webhooks/parse.html)

## Mailgun Example

```ruby
class EmailReceiver < Incoming::Strategies::Mailgun
  setup api_key: "asdf"

  def receive(mail)
    %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[Mailgun API reference](http://documentation.mailgun.net/user_manual.html#receiving-messages)

## Postmark Example

```ruby
class EmailReceiver < Incoming::Strategies::Postmark
  def receive(mail)
    %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[Postmark API reference](http://developer.postmarkapp.com/developer-inbound.html)

## CloudMailin Example

Use the Raw Format when setting up your address target.

```ruby
class EmailReceiver < Incoming::Strategies::CloudMailin
  def receive(mail)
    %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[CloudMailin API reference](http://docs.cloudmailin.com/http_post_formats/)

## Mandrill Example

Mandrill is capable of sending multiple events in a single webhook, so
the Mandrill strategy works a bit differently than the others. Namely,
the `.receive` method returns an Array of return values from your
`#receive` method for each inbound event in the payload. Otherwise, the
implementation is the same:

```ruby
class EmailReceiver < Incoming::Strategies::Mandrill
  def receive(mail)
    %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[Mandrill API reference](http://help.mandrill.com/entries/22092308-What-is-the-format-of-inbound-email-webhooks-)

## Postfix Example

```ruby
class EmailReceiver < Incoming::Strategies::HTTPPost
  setup secret: "6d7e5337a0cd69f52c3fcf9f5af438b1"

  def receive(mail)
    %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

```
# /etc/postfix/virtual
@example.com http_post

# /etc/mail/aliases
http_post: "|http_post -s 6d7e5337a0cd69f52c3fcf9f5af438b1 http://www.example.com/emails"
```
## Qmail Example:

```ruby
class EmailReceiver < Incoming::Strategies::HTTPPost
  setup secret: "6d7e5337a0cd69f52c3fcf9f5af438b1"

  def receive(mail)
    %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

To setup a *global* incoming email alias:

```
# /var/qmail/alias/.qmail-whoever - mails to whoever@ will be delivered to this alias.
|http_post -s 6d7e5337a0cd69f52c3fcf9f5af438b1 http://www.example.com/emails
```

Domain-specific incoming aliases can be set as follows:

```
#/var/qmail/control/virtualdomains
example.com:example

#~example/.qmail-whoever
|http_post -s 6d7e5337a0cd69f52c3fcf9f5af438b1 http://www.example.com/emails
```
Now mails to `whoever@example.com` will be posted to the corresponding URL above. To post all mails for `example.com`, just add the above line to `~example/.qmail-default`.

## Example Rails Controller

```ruby
# app/controllers/emails_controller.rb
class EmailsController < ActionController::Base
  def create
    if EmailReceiver.receive(request)
      render json: { status: "ok" }
    else
      render json: { status: "rejected" }, status: 403
    end
  end
end
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  post "/emails" => "emails#create"
end
```

```ruby
# spec/controllers/emails_controller_spec.rb
require "spec_helper"

describe EmailsController, "#create" do
  it "responds with success when request is valid" do
    allow(EmailReceiver).to receive(:receive).and_return(true)
    post :create
    expect(response.success?).to eq(true)
    expect(response.body).to eq(%({"status":"ok"}))
  end

  it "responds with 403 when request is invalid" do
    allow(EmailReceiver).to receive(:receive).and_return(false)
    post :create
    expect(response.status).to eq(403)
    expect(response.body).to eq(%({"status":"rejected"}))
  end
end
```

## TODO

1. Provide authentication for all strategies where possible (currently
   only Mailgun requests are authenticated.)

## Contributing

1. Fork it.
2. Create a topic branch `git checkout -b my_branch`
3. Commit your changes `git commit -am "Boom"`
3. Push to your branch `git push origin my_branch`
4. Send a [pull request](https://github.com/honeybadger-io/incoming/pulls)

## License

Incoming! is free software, and may be redistributed under the terms specified
in the MIT-LICENSE file.
