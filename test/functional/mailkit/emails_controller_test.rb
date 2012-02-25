require 'test_helper'

module Mailkit
  class EmailsControllerTest < ActionController::TestCase

    test 'it responds with success when request is received' do
      MailReceiver.expects(:receive).returns(true)
      post :create, receiver: 'mail_receiver'
      assert_response :success
      assert_equal('{"status":"ok"}', @response.body)
    end

    test 'it responds with 403 when request is invalid' do
      MailReceiver.expects(:receive).returns(false)
      post :create, receiver: 'mail_receiver'
      assert_response :success
      assert_equal('{"status":"rejected"}', @response.body)
    end

  end
end
