module Mailkit
  class Mailer < ActionMailer::Base
    def receive(mail)
      mail
    end
  end
end