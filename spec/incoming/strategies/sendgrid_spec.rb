require 'spec_helper'

describe Incoming::Strategies::SendGrid do
  before do
    @params = {
      'SPF' => 'pass',
      'charsets' => '{"from": "UTF-8", "subject": "UTF-8", "text": "ISO-8859-1", "to": "UTF-8"}',
      'dkim' => 'none',
      'envelope' => JSON.generate({
        'to' => ['testing@sendgrid.honeybadger.io'],
        'from' => 'josh@honeybadger.io'
      }),
      'from' => 'Joshua Wood <josh@honeybadger.io>',
      'headers' => "Received: by 127.0.0.1 with SMTP id IQklCWgXx9 Tue, 30 Apr 2013 20:38:01 -0500 (CDT)\r\nReceived: from mail-da0-f49.google.com (mail-da0-f49.google.com [209.85.210.49]) by mx3.sendgrid.net (Postfix) with ESMTPS id 15F7314F48C1 for <testing@sendgrid.honeybadger.io>; Tue, 30 Apr 2013 20:38:01 -0500 (CDT)\r\nReceived: by mail-da0-f49.google.com with SMTP id t11so483187daj.22 for <testing@sendgrid.honeybadger.io>; Tue, 30 Apr 2013 18:38:00 -0700 (PDT)\r\nX-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113; h=x-received:message-id:date:from:user-agent:mime-version:to:subject :x-enigmail-version:content-type:content-transfer-encoding :x-gm-message-state; bh=EVfAHeUMDygbJe0SkMWJHjgXGjtiTLZnMQbyWqzsrCY=; b=Y5UefHXzM6KLBH/TQejxrMlJ3sPJThU1DS0/uNLWUZkjeG4wAwOEfE8XuesBL7SUF1 0G6OAlCqpnZMl8F8iitlt2iuuW1+5NqOiBIsBnYFJ5Y5EP8XiPivUaigWZLtGfZH7sTY 2tNQ74UfVSzxx5gyjajkzuT8qNa+zYiNVL14wQy2HWu/FxTUBGy5VRko7hVXdJIck7fn 4E+4p34f1j2CGPSYXg4qDgBwE4m4nllQqu0/k/xHB66+iJl05uMZ2BUGYoRQI2aE4jC1 GlbxQhUU5I/kefIjrdm1wuf92sarKTtFA6kcao1Z3pgExARbcpuXTdgIsgq/WUBf424U JCnQ==\r\nX-Received: by 10.66.177.46 with SMTP id cn14mr2412679pac.4.1367372280251; Tue, 30 Apr 2013 18:38:00 -0700 (PDT)\r\nReceived: from Josh-MacBook-Air.local (c-67-171-132-75.hsd1.or.comcast.net. [67.171.132.75]) by mx.google.com with ESMTPSA id ef4sm782898pbd.38.2013.04.30.18.37.57 for <testing@sendgrid.honeybadger.io> (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128); Tue, 30 Apr 2013 18:37:59 -0700 (PDT)\r\nMessage-ID: <518071F1.5010108@honeybadger.io>\r\nDate: Tue, 30 Apr 2013 18:37:53 -0700\r\nFrom: Joshua Wood <josh@honeybadger.io>\r\nUser-Agent: Postbox 3.0.8 (Macintosh/20130427)\r\nMIME-Version: 1.0\r\nTo: testing@sendgrid.honeybadger.io\r\nSubject: Matterhorn\r\nX-Enigmail-Version: 1.2.3\r\nContent-Type: text/plain; charset=ISO-8859-1\r\nContent-Transfer-Encoding: 7bit\r\nX-Gm-Message-State: ALoCoQkHpc+fg75T6PPAtGWRMs8lDGZtyRSNSt4DRh7Gm29YjOKj4VThC/EdJAiqrqkuRX1HKyA6",
      'subject' => 'Matterhorn',
      'text' => 'We should do that again sometime.',
      'html' => '<strong>We should do that again sometime</strong>',
      'to' => 'testing@sendgrid.honeybadger.io',
      'attachments' => '2',
      'attachment1' => stub(:original_filename => 'hello.txt', :read => 'hello world'),
      'attachment2' => {
        'filename' => 'bar.txt',
        'type' => 'text/plain',
        'name' => 'attachment-2',
        'tempfile' => stub(:read => 'hullo world'),
        'head' => "Content-Disposition: form-data; name=\"attachment-2\"; filename=\"bar.txt\"\r\nContent-Type: text/plain\r\nContent-Length: ll\r\n"
      }
    }

    @mock_request = stub()
    @mock_request.stub(:params).and_return(@params)
  end

  describe 'message' do
    subject { receiver.receive(@mock_request) }

    it { should be_a Mail::Message }

    its('to.first') { should eq 'testing@sendgrid.honeybadger.io' }
    its('from.first') { should eq 'josh@honeybadger.io' }
    its('subject') { should eq @params['subject'] }
    its('body.decoded') { should eq @params['text'] }
    its('text_part.body.decoded') { should eq @params['text'] }
    its('html_part.body.decoded') { should eq @params['html'] }
    its('attachments.first.filename') { should eq 'hello.txt' }
    its('attachments.first.read') { should eq 'hello world' }
    its('attachments.last.filename') { should eq 'bar.txt' }
    its('attachments.last.read') { should eq 'hullo world' }
  end
end
