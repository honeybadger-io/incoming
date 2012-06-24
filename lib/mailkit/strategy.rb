module Mailkit
  module Strategy
    def self.included(base)
      base.extend ClassMethods
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

      # Public: Strategy-specific options
      #
      # Returns the options configuration object
      def options
        @options ||= OpenStruct.new(default_options)
      end

      # Public: Configures strategy-specific options.
      #
      # opts  - A hash of options. Valid keys must be defined in `#default_options`
      #         on the strategy class. (optional)
      # block - An optional block that can be used to set options directly.
      #
      # Examples:
      #
      #   # Set options using a block
      #   class MailReceiver < Mailkit::Strategies::MyStrategy
      #     setup do |options|
      #       options.api_key = 'asdf'
      #       options.mime = true
      #     end
      #   end
      #
      #   # Set options using a hash
      #   class MailReceiver < Mailkit::Strategies::MyStrategy
      #     setup api_key: 'asdf', mime: true
      #   end
      #
      # Returns nothing
      def setup(opts = {}, &block)
        if block_given?
          yield(options)
        else
          opts.each_pair do |key, value|
            if default_options.keys.include?(key)
              options.send(:"#{key}=", value)
            else
              raise InvalidOptionError.new(":#{key} is not a valid option for #{self.superclass.name}.")
            end
          end
        end
      end

      protected

      # Protected: Each strategy may provide its own options, which are configured
      # by the `setup` method when defining a subclass. `#default_options` must be
      # defined by the strategy in order to take advantage of this feature.
      #
      # Examples:
      #
      #   # In strategy:
      #
      #   protected
      #
      #   def default_options
      #     {
      #       api_key: nil,
      #       mime: false
      #     }.freeze
      #   end
      #
      # Returns a hash of default options for strategy
      def default_options
        {}.freeze
      end
    end

    # Public: A Mail::Message object, constructed by #initialize
    attr_accessor :message

    # Public: Translates arguments into a Mail::Message object
    def initialize(*args) ; end

    protected

    # Protected: Authenticates request before performing #receive
    #
    # Examples:
    #
    #   class MailReceiver < Mailkit::Strategies::MyStrategy
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

    # Protected: Evaluates message and performs appropriate action.
    # Override in subclass
    #
    # mail - A Mail::Message object
    #
    # Returns nothing
    def receive(mail)
      raise NotImplementedError.new('You must implement #receive')
    end
  end
end
