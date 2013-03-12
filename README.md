Incoming!
-----------

### Receive email in your Rack apps.

Incoming! receives a `Rack::Request` and hands you a [`Mail::Message`](https://github.com/mikel/mail/), much
like `ActionMailer::Base.receive` does with a raw email. We currently
support the following services:

1. SendGrid
2. Mailgun
3. Postmark
4. CloudMailin
5. Any mail server capable of routing messages to a system command

Brought to you by :zap: **Honeybadger.io**, painless [Rails exception tracking](https://www.honeybadger.io/).

[![Build Status](https://travis-ci.org/honeybadger-io/incoming.png)](https://travis-ci.org/honeybadger-io/incoming)
[![Gem Version](https://badge.fury.io/rb/incoming.png)](http://badge.fury.io/rb/incoming)

## Installation

1. Add Incoming! to your Gemfile and run `bundle install`:

    ```ruby
    gem 'incoming'
    ```

2. Create a new class to receive emails (see examples below)

3. Implement an HTTP endpoint to receive HTTP post hooks, and pass the
   request to your receiver. (see examples below)

## SendGrid example:

```ruby
class EmailReceiver < Incoming::Strategies::SendGrid
  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[Sendgrid API reference](http://sendgrid.com/docs/API_Reference/Webhooks/parse.html)

## Mailgun example:

```ruby
class EmailReceiver < Incoming::Strategies::Mailgun
  setup :api_key => 'asdf'

  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[Mailgun API reference](http://documentation.mailgun.net/user_manual.html#receiving-messages)

## Postmark example:

```ruby
class EmailReceiver < Incoming::Strategies::Postmark
  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[Postmark API reference](http://developer.postmarkapp.com/developer-inbound.html)

## CloudMailin example:

Use the Raw Format when setting up your address target.

```ruby
class EmailReceiver < Incoming::Strategies::CloudMailin
  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

[CloudMailin API reference](http://docs.cloudmailin.com/http_post_formats/)

## Postfix example:

```ruby
class EmailReceiver < Incoming::Strategies::HTTPPost
  setup :secret => '6d7e5337a0cd69f52c3fcf9f5af438b1'

  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
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
## Qmail example:

```ruby
class EmailReceiver < Incoming::Strategies::HTTPPost
  setup :secret => '6d7e5337a0cd69f52c3fcf9f5af438b1'

  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
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

## Example Rails controller

```ruby
# app/controllers/emails_controller.rb
class EmailsController < ActionController::Base
  def create
    if EmailReceiver.receive(request)
      render :json => { :status => 'ok' }
    else
      render :json => { :status => 'rejected' }, :status => 403
    end
  end
end
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  post '/emails' => 'emails#create'
end
```

```ruby
# spec/controllers/emails_controller_spec.rb
require 'spec_helper'

describe EmailsController, '#create' do
  it 'responds with success when request is valid' do
    EmailReceiver.should_receive(:receive).and_return(true)
    post :create
    response.should be_success
    response.body.should eq '{"status":"ok"}'
  end

  it 'responds with 403 when request is invalid' do
    EmailReceiver.should_receive(:receive).and_return(false)
    post :create
    response.status.should eq 403
    response.body.should eq '{"status":"rejected"}'
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

Incoming! is Copyright 2013 © Joshua Wood and Honeybadger Industries LLC. It is free software, and
may be redistributed under the terms specified in the MIT-LICENSE file.
