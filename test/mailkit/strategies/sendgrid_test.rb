require 'test_helper'

class TestSendgrid < ActiveSupport::TestCase

  def setup
    @params = {
      :envelope => JSON.generate({
        :to => ['jack@example.com'],
        :from => 'japhy@example.com'
      }),
      :subject => 'Matterhorn',
      :text => 'We should do that again sometime.'
    }

    @mock_request = mock()
    @mock_request.expects(:params).returns(@params)
  end

  test 'maps request parameters to correct attributes' do
    sendgrid = Mailkit::Strategies::Sendgrid.new(@mock_request)

    assert_equal('jack@example.com', sendgrid.to)
    assert_equal('japhy@example.com', sendgrid.from)
    assert_equal(@params[:subject], sendgrid.subject)
    assert_equal(@params[:text], sendgrid.body)
  end

end