module Mailkit
  module Strategy
    attr_accessor :to, :from, :subject, :body, :attachments

    # Translates arguments into standard setter/getter methods
    def initialize(*args) ; end

    # Global receiver
    def self.receive(options = {}, *args)
      email = new(*args)
      email.authenticate(options) and email.receive
    end
    
    # Authenticates request before performing #receive
    def authenticate(options = {})
      true
    end
    
    protected
    # Evaluates message and performs appropriate action
    # Override in subclass
    def receive ; end
  end
end