require 'spec_helper'

describe Incoming::Strategies::Mailgun do
  let(:receiver) { test_receiver(:api_key => 'asdf') }

  before do
    @params = {
      'recipient' => 'testing@honeybadger.mailgun.org',
      'sender' => 'josh@honeybadger.io',
      'from' => 'Joshua Wood <josh@honeybadger.io>',
      'subject' => 'Matterhorn',
      'body-plain' => "We should do that again sometime.\n> Quoted part",
      'body-html' => '<strong>We should do that again sometime.</strong>\r\n> <em>Quoted part</em>',
      'stripped-text' => 'We should do that again sometime.',
      'stripped-html' => '<strong>We should do that again sometime.</strong>',
      'signature' => 'foo',
      'message-headers' => [ [ "Received", "by luna.mailgun.net with SMTP mgrt 8786320665205; Wed, 01 May 2013 01:27:31 +0000" ], [ "X-Envelope-From", "<josh@honeybadger.io>" ], [ "Received", "from mail-pa0-f47.google.com (mail-pa0-f47.google.com [209.85.220.47]) by mxa.mailgun.org with ESMTP id 51806f82.7efee87f6a70-in1; Wed, 01 May 2013 01:27:30 -0000 (UTC)" ], [ "Received", "by mail-pa0-f47.google.com with SMTP id bj3so645042pad.6 for <testing@honeybadger.mailgun.org>; Tue, 30 Apr 2013 18:27:29 -0700 (PDT)" ], [ "X-Google-Dkim-Signature", "v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113; h=x-received:message-id:date:from:user-agent:mime-version:to:subject :x-enigmail-version:content-type:content-transfer-encoding :x-gm-message-state; bh=yZQq1c8wjBl0fZ4Wc/oraMCAG1mZJv5v/hlvyFy+t6A=; b=Vgzjw5DlUSYuw81apkhCqY5j83vdr3Qc6FiEHyiOtNubTqWAEHe8YH3GumyEjwt2lq IeX9/a9YH8cxUIJYCIQ7qHlunXke/IzmypFCjHjyNa4Hcm97KpUgdQ/REc7/7yXjIZ/Z CsE4afdhOpfz1Q7uXYw+LGUHWfF48N82QQVHZp/FyYQcIO0Mk1oVnKgRlQRc/+p7YP+W 8pyybPdTRAg4TvGt0dBoMuKapJbbkHYJyQa1c+JDHWjzGEnX3fdQIYPE8YWzUserEA6/ LLnoUyLVmSwz3A18Ycpoli3RaJkFrdKVwVb1WSMSE/tberAuAhXAs+XJ9uapC+6hMrPO 6FpQ==" ], [ "X-Received", "by 10.68.220.2 with SMTP id ps2mr1421811pbc.51.1367371649529; Tue, 30 Apr 2013 18:27:29 -0700 (PDT)" ], [ "Return-Path", "<josh@honeybadger.io>" ], [ "Received", "from Josh-MacBook-Air.local (c-67-171-132-75.hsd1.or.comcast.net. [67.171.132.75]) by mx.google.com with ESMTPSA id gi2sm816114pbb.2.2013.04.30.18.27.27 for <testing@honeybadger.mailgun.org> (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128); Tue, 30 Apr 2013 18:27:28 -0700 (PDT)" ], [ "Message-Id", "<51806F7B.3080208@honeybadger.io>" ], [ "Date", "Tue, 30 Apr 2013 18:27:23 -0700" ], [ "From", "Joshua Wood <josh@honeybadger.io>" ], [ "User-Agent", "Postbox 3.0.8 (Macintosh/20130427)" ], [ "Mime-Version", "1.0" ], [ "To", "testing@honeybadger.mailgun.org" ], [ "Subject", "Matterhorn" ], [ "X-Enigmail-Version", "1.2.3" ], [ "Content-Type", "text/plain; charset=\"ISO-8859-1\"" ], [ "Content-Transfer-Encoding", "7bit" ], [ "X-Gm-Message-State", "ALoCoQlVbkIehDACf3uTH1cKcdwdTq2pg+C7Wu2rsW0LR56YibUbKCsm1iTs8/iYMK76W9qToNZt" ], [ "X-Mailgun-Incoming", "Yes" ] ].to_json,
      'attachment-count' => '2',
      'attachment-1' => stub(:original_filename => 'foo.txt', :read => 'hello world'),
      'attachment-2' => {
        'filename' => 'bar.txt',
        'type' => 'text/plain',
        'name' => 'attachment-2',
        'tempfile' => stub(:read => 'hullo world'),
        'head' => "Content-Disposition: form-data; name=\"attachment-2\"; filename=\"bar.txt\"\r\nContent-Type: text/plain\r\nContent-Length: 11\r\n"
      }
    }

    @mock_request = stub()
    @mock_request.stub(:params).and_return(@params)
  end

  describe 'non-mime request' do
    describe 'receive' do
      subject { receiver.receive(@mock_request) }
      before(:each) { OpenSSL::HMAC.stub(:hexdigest).and_return('foo') }

      it { should be_a Mail::Message }

      its('to.first') { should eq @params['recipient'] }
      its('from.first') { should eq @params['sender'] }
      its('subject') { should eq @params['subject'] }
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
    mailgun.authenticate.should be_false
  end

  it 'authenticates when hexidigest is valid' do
    OpenSSL::HMAC.stub(:hexdigest).and_return('foo')
    mailgun = receiver.new(@mock_request)
    mailgun.authenticate.should be_true
  end

  it 'raises an exception when api key is not provided' do
    expect {
      test_receiver(:api_key => nil).new(@mock_request)
    }.to raise_error Incoming::Strategy::RequiredOptionError
  end
end
