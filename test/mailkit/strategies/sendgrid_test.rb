require 'test_helper'

describe Mailkit::Strategies::Sendgrid do
  before do
    @params = {
      :SPF => 'pass',
      :charsets => '{"from": "UTF-8", "subject": "UTF-8", "text": "ISO-8859-1", "to": "UTF-8"}',
      :dkim => 'none',
      :envelope => JSON.generate({
        :to => ['jack@example.com'],
        :from => 'japhy@example.com'
      }),
      :from => 'Japhy Ryder <japhy@example.com>',
      :headers => '',
      :subject => 'Matterhorn',
      :text => 'We should do that again sometime.',
      :html => '<strong>We should do that again sometime</strong>',
      :to => 'jack@example.com'
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(@params)
  end

  it 'maps request parameters to correct attributes' do
    sendgrid = Mailkit::Strategies::Sendgrid.new(@mock_request)

    assert_kind_of Mail::Message, sendgrid.message

    assert_equal 'jack@example.com', sendgrid.message.to[0]
    assert_equal 'japhy@example.com', sendgrid.message.from[0]
    assert_equal @params[:subject], sendgrid.message.subject
    assert_equal @params[:text], sendgrid.message.body.decoded
    assert_equal @params[:text], sendgrid.message.text_part.body.decoded
    assert_equal @params[:html], sendgrid.message.html_part.body.decoded
  end
end
