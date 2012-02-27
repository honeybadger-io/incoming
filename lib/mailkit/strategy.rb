module Mailkit
  module Strategy
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Global receiver
      def receive(options = {}, *args)
        email = new(*args)
        email.authenticate(options) and email.receive
      end
    end
    
    attr_accessor :to, :from, :subject, :body, :attachments

    # Translates arguments into standard setter/getter methods
    def initialize(*args) ; end
    
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