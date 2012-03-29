require 'test_helper'

class TestSendgrid < ActiveSupport::TestCase

  def setup
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
      :to => 'jack@example.com'
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(@params)
  end

  test 'maps request parameters to correct attributes' do
    sendgrid = Mailkit::Strategies::Sendgrid.new(@mock_request)

    assert_equal('jack@example.com', sendgrid.to)
    assert_equal('Japhy Ryder <japhy@example.com>', sendgrid.from)
    assert_equal(@params[:subject], sendgrid.subject)
    assert_equal(@params[:text], sendgrid.body)
  end

end
