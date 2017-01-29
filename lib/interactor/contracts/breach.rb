module Interactor
  module Contracts
    # A wrapper for breached contract terms that encapsulates the failed
    # property and its messages.
    class Breach
      # Represents a breach of a contract with its messages
      #
      # @example
      #   Interactor::Contracts::Breach.new(:name, ["name is missing"])
      #
      # @api semipublic
      # @param [Symbol] property the property violated in the contract
      # @param [Array<String>] messages the messages describing the breach.
      def initialize(property, messages)
        @property = property
        @messages = messages
      end

      # The messages describing the breach
      #
      # @example
      #   breach = Interactor::Contracts::Breach.new(:name, ["name is missing"])
      #   breach.messages  #=> ["name is missing"]
      #
      # @api public
      # @return [Array<String>] the messages describing the breach
      attr_reader :messages

      # The property violated in the contract
      #
      # @example
      #   breach = Interactor::Contracts::Breach.new(:name, ["name is missing"])
      #   breach.property  #=> :name
      #
      # @api public
      # @return [Symbol] the property violated in the contract
      attr_reader :property
    end
  end
end
