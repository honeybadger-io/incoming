module Incoming
  module Strategy
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        attr_reader :options
      end
    end

    class RequiredOptionError < StandardError ; end
    class InvalidOptionError < StandardError ; end

    module ClassMethods
      # Public: Global receiver
      #
      # args - Arguments used to initialize strategy. Should be defined
      #        by `initialize` method in strategy class.
      #
      # Returns nothing
      def receive(*args)
        strategy = new(*args)
        strategy.authenticate and strategy.receive(strategy.message)
      end

      # Public
      # Returns an inherited set of default options set at the class-level
      # for each strategy.
      def default_options
        return @default_options if @default_options
        @default_options = superclass.respond_to?(:default_options) ? superclass.default_options : {}
      end

      # Public: Defines a valid class-level option for strategy
      #
      # Examples:
      #
      #   class Incoming::Strategies::MyStrategy
      #     include Incoming::Strategy
      #     option :api_key
      #     option :mime, false
      #   end
      #
      # Returns nothing
      def option(name, value = nil)
        default_options[name] = value
      end

      # Public: Configures strategy-specific options.
      #
      # opts  - A hash of valid options.
      #
      # Examples:
      #
      #   class MailReceiver < Incoming::Strategies::MyStrategy
      #     setup api_key: 'asdf', mime: true
      #   end
      #
      # Returns nothing
      def setup(opts = {})
        opts.keys.each do |key|
          next if default_options.keys.include?(key)
          raise InvalidOptionError.new(":#{key} is not a valid option for #{self.superclass.name}.")
        end

        @default_options = default_options.merge(opts)
      end
    end

    # Public: A Mail::Message object, constructed by #initialize
    attr_accessor :message

    # Public: Translates arguments into a Mail::Message object
    def initialize(*args) ; end

    # Public: Evaluates message and performs appropriate action.
    # Override in subclass
    #
    # mail - A Mail::Message object
    #
    # Returns nothing
    def receive(mail)
      raise NotImplementedError.new('You must implement #receive')
    end

    # Public: Authenticates request before performing #receive
    #
    # Examples:
    #
    #   class MailReceiver < Incoming::Strategies::MyStrategy
    #     def initialize(request)
    #       @secret_word = request.params['secret_word']
    #     end
    #
    #     def protected
    #       @secret_word == 'my secret word'
    #     end
    #   end
    #
    # Returns true by default
    def authenticate
      true
    end
  end
end
