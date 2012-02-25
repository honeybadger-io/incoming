class MailReceiver < Mailkit::Strategies::Raw
  def receive
    # Perform superclass validation
    super
  end
end