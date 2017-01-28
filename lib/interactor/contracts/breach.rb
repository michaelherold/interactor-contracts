module Interactor
  module Contracts
    # A wrapper for breached contract terms that encapsulates the failed
    # property and its messages.
    class Breach
      # @param [Symbol] property the property violated in the contract
      # @param [Array<String>] messages the messages describing the breach.
      def initialize(property, messages)
        @property = property
        @messages = messages
      end

      # The messages describing the breach.
      #
      # @!attribute [r] messages
      #   @return [Array<String>] the messages describing the breach
      attr_reader :messages

      # The property violated in the contract.
      #
      # @!attribute [r] property
      #   @return [Symbol] the property violated in the contract
      attr_reader :property
    end
  end
end
