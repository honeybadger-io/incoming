module Mailkit
  module Strategy
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Global receiver
      def receive(options = {}, *args)
        email = new(*args)
        email.options(options)
        email.authenticate and email.receive
      end

      # Accepts a hash that overrides any existing default option values
      # Returns default options hash
      def default_options(options = {})
        @default_options ||= {}
        @default_options.reverse_merge!(options)

        @default_options
      end
    end

    attr_accessor :to, :from, :subject, :body, :attachments

    # Translates arguments into standard setter/getter methods
    def initialize(*args) ; end
    
    # Authenticates request before performing #receive
    def authenticate
      true
    end
    
    # Accepts a hash that overrides any existing option values
    # Returns options hash
    def options(options = {})
      @options ||= self.class.default_options
      @options.reverse_merge!(options)

      @options
    end
    
    protected
    # Evaluates message and performs appropriate action
    # Override in subclass
    def receive ; end
  end
end