Incoming!
-----------

Incoming! helps you receive email in your Rack apps.

Brought to you by :zap: **Honeybadger.io**, painless [Rails exception tracking](https://www.honeybadger.io/).

## Sendgrid example:

```ruby
class EmailReceiver < Incoming::Strategies::Sendgrid
  def receive(mail)
    puts %(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
end

req = Rack::Request.new(env)
result = EmailReceiver.receive(req) # => Got message from whoever@wherever.com with subject "hello world"
```

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
# Postfix virtual alias
http_post: "|http_post -s 6d7e5337a0cd69f52c3fcf9f5af438b1 http://www.example.com/emails"
```

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

## Contributing

1. Fork it.
2. Create a topic branch `git checkout -b my_branch`
3. Commit your changes `git commit -am "Boom"`
3. Push to your branch `git push origin my_branch`
4. Send a [pull request](https://github.com/honeybadger-io/incoming/pulls)

## License

Incoming! is Copyright 2013 © Honeybadger Industries LLC. It is free software, and
may be redistributed under the terms specified in the MIT-LICENSE file.
