module Interactor
  module Contracts
    # A wrapper for contract violations that encapsulates the failed property
    # and its messages.
    class Violation
      # @param [Symbol] property the property violated in the contract
      # @param [Array<String>] messages the messages describing the violation.
      def initialize(property, messages)
        @property = property
        @messages = messages
      end

      # The messages describing the violation.
      #
      # @!attribute [r] messages
      #   @return [Array<String>] the messages describing the violation
      attr_reader :messages

      # The property violated in the contract.
      #
      # @!attribute [r] property
      #   @return [Symbol] the property violated in the contract
      attr_reader :property
    end
  end
end
