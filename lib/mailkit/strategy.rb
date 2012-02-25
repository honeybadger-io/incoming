module Mailkit
  module Strategy
    attr_accessor :to, :from, :subject, :body, :attachments

    def initialize(*args)
    end

    # Global receiver
    def self.receive(*args)
      new(*args).receive
    end

    # Evaluates message and performs appropriate action
    def receive ; end
  end
end