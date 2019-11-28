require 'spec_helper'

describe Incoming::Strategies::Mailgun do
  let(:receiver) { test_receiver(:api_key => 'asdf') }

  before do
    @params = {
      'body-plain' => "We should do that again sometime.\n> Quoted part",
      'body-html' => '<strong>We should do that again sometime.</strong>\r\n> <em>Quoted part</em>',
      'stripped-text' => 'We should do that again sometime.',
      'stripped-html' => '<strong>We should do that again sometime.</strong>',
      'signature' => 'foo',
      'message-headers' => [ [ "Received", "by luna.mailgun.net with SMTP mgrt 8747120609393; Wed, 01 May 2013 02:16:10 +0000" ], [ "X-Envelope-From", "<josh@honeybadger.io>" ], [ "Received", "from mail-pa0-f41.google.com (mail-pa0-f41.google.com [209.85.220.41]) by mxa.mailgun.org with ESMTP id 51807ae9.7f7248df4ef0-in3; Wed, 01 May 2013 02:16:09 -0000 (UTC)" ], [ "Received", "by mail-pa0-f41.google.com with SMTP id kq12so669142pab.0 for <testing@honeybadger.mailgun.org>; Tue, 30 Apr 2013 19:16:05 -0700 (PDT)" ], [ "X-Google-Dkim-Signature", "v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113; h=x-received:message-id:date:from:user-agent:mime-version:to:subject :x-enigmail-version:content-type:content-transfer-encoding :x-gm-message-state; bh=Ba3gj8+xBPQLJTahTfzW6RbWQ/XPgESxkCi2B66PSQg=; b=A2UmxKvNxZAr4yAWPWDfnBELJC8yBfthL7pxex51u3JYLvWdPjhmuJMeaUtSNkBVq1 7nWT8/OrnaXAACeBZc/WFjMNP5BTC+B3Eic4387QseWkqrE17oQSQWBupkzUzW+JLdeD /BEDVhPglhkeOQhtdd3iooRCVAZ++DzDv4zKYOXlNbuvNnDO1D+RVoRkBx6sA+fom8vJ l0HYkqfzVqelt8FKVfQ50J/KFPfItzYuh37Uck54lV6zoE2dGyK5uvNqyEMzNLPnd1PI XC1t8G/61I8lGl0MMdju6KD31flClhcmEr282c1YMXzGTWtgD22t39snAk9sI0Ce31Dv dGlw==" ], [ "X-Received", "by 10.66.220.10 with SMTP id ps10mr2456146pac.117.1367374564998; Tue, 30 Apr 2013 19:16:04 -0700 (PDT)" ], [ "Return-Path", "<josh@honeybadger.io>" ], [ "Received", "from Josh-MacBook-Air.local (c-67-171-132-75.hsd1.or.comcast.net. [67.171.132.75]) by mx.google.com with ESMTPSA id ya4sm939634pbb.24.2013.04.30.19.16.02 for <multiple recipients> (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128); Tue, 30 Apr 2013 19:16:04 -0700 (PDT)" ], [ "Message-Id", "<51807AE0.2020403@honeybadger.io>" ], [ "Date", "Tue, 30 Apr 2013 19:16:00 -0700" ], [ "From", "Joshua Wood <josh@honeybadger.io>" ], [ "User-Agent", "Postbox 3.0.8 (Macintosh/20130427)" ], [ "Mime-Version", "1.0" ], [ "To", "testing@honeybadger.mailgun.org, Wood Joshua <joshuawood@gmail.com>" ], [ "Subject", "Matterhorn" ], [ "X-Enigmail-Version", "1.2.3" ], [ "Content-Type", "text/plain; charset=\"ISO-8859-1\"" ], [ "Content-Transfer-Encoding", "7bit" ], [ "X-Gm-Message-State", "ALoCoQmejbb0rnWD00BBdqBXLoONkEpAYyufP56rBpr80ZKyDXNN1/t/O9MRqscRmoLVPrE9tu+G" ], [ "X-Mailgun-Incoming", "Yes" ] ].to_json,
      'attachment-count' => '2',
      'attachment-1' => double(:original_filename => 'foo.txt', :read => 'hello world'),
      'attachment-2' => {
        :filename => 'bar.txt',
        :tempfile => double(:read => 'hullo world')
      }
    }

    @mock_request = double()
    @mock_request.stub(:params).and_return(@params)
  end

  describe 'non-mime request' do
    describe 'receive' do
      subject { receiver.receive(@mock_request) }
      before(:each) { OpenSSL::HMAC.stub(:hexdigest).and_return('foo') }

      it { should be_a Mail::Message }

      its('to') { should include 'testing@honeybadger.mailgun.org' }
      its('to') { should include 'joshuawood@gmail.com' }
      its('from.first') { should eq 'josh@honeybadger.io' }
      its('subject') { should eq 'Matterhorn' }
      its('body.decoded') { should eq @params['body-plain'] }
      its('text_part.body.decoded') { should eq @params['body-plain'] }
      its('html_part.body.decoded') { should eq @params['body-html'] }
      its('attachments.first.filename') { should eq 'foo.txt' }
      its('attachments.first.read') { should eq 'hello world' }
      its('attachments.last.filename') { should eq 'bar.txt' }
      its('attachments.last.read') { should eq 'hullo world' }

      context 'stripped option is true' do
        let(:receiver) { test_receiver(:api_key => 'asdf', :stripped => true) }

        it { should be_a Mail::Message }

        its('body.decoded') { should eq @params['stripped-text'] }
        its('text_part.body.decoded') { should eq @params['stripped-text'] }
        its('html_part.body.decoded') { should eq @params['stripped-html'] }
      end
    end
  end

  it 'returns false from #authenticate when hexidigest is invalid' do
    OpenSSL::HMAC.stub(:hexdigest).and_return('bar')
    mailgun = receiver.new(@mock_request)
    mailgun.authenticate.should eq(false)
  end

  it 'authenticates when hexidigest is valid' do
    OpenSSL::HMAC.stub(:hexdigest).and_return('foo')
    mailgun = receiver.new(@mock_request)
    mailgun.authenticate.should eq(true)
  end

  it 'raises an exception when api key is not provided' do
    expect {
      test_receiver(:api_key => nil).new(@mock_request)
    }.to raise_error Incoming::Strategy::RequiredOptionError
  end
end
