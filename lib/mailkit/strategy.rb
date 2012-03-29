require 'ostruct'

module Mailkit
  module Strategy
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Global receiver
      def receive(*args)
        strategy = new(*args)
        strategy.authenticate and strategy.receive(strategy.message)
      end

      # Strategy-specific options
      def options
        @options ||= OpenStruct.new(default_options)
      end

      # Yields options for configuration
      def setup(options = {})
        if block_given?
          yield(options)
        else
          @options = OpenStruct.new(default_options.merge(options))
        end
      end

      protected
      def default_options
        {}
      end
    end

    attr_accessor :message

    # Translates arguments into standard setter/getter methods
    def initialize(*args) ; end

    # Authenticates request before performing #receive
    def authenticate
      true
    end

    protected
    # Evaluates message and performs appropriate action
    # Override in subclass
    def receive ; end
  end
end
