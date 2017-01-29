require "forwardable"
require "interactor/contracts/breach"

module Interactor
  module Contracts
    # The outcome of a Terms enforcement.
    class Outcome
      extend Forwardable

      # Instantiantes a new Outcome based on the results of a Terms enforcement
      #
      # @api private
      # @param [Dry::Validation::Result] result
      def initialize(result)
        @result = result
      end

      # @!method success?
      #   Checks whether the the terms enforcement was a success
      #
      #   @example
      #     terms = Interactor::Contract::Terms.new
      #     terms.add do
      #       required(:name).filled
      #     end
      #
      #     outcome = terms.call(:name => "Bilbo Baggins")
      #     outcome.success?  #=> true
      #
      #   @api semipublic
      #   @return [Boolean]
      def_delegator :@result, :success?

      # The list of breaches of the Terms
      #
      # @example
      #   terms = Interactor::Contract::Terms.new
      #   terms.add do
      #     required(:name).filled
      #   end
      #
      #   outcome = terms.call(:name => "Bilbo Baggins")
      #   outcome.breaches  #=> []
      #
      # @api semipublic
      # @return [Array<Breach>] the breaches of the Terms' constraints
      def breaches
        return [] if success?

        result.messages.map do |property, messages|
          Breach.new(property, messages)
        end
      end

      # Checks whether the the Terms enforcement was a failure
      #
      # @example
      #   terms = Interactor::Contract::Terms.new
      #   terms.add do
      #     required(:name).filled
      #   end
      #
      #   outcome = terms.call(:name => "Bilbo Baggins")
      #   outcome.failure?  #=> false.
      #
      # @api semipublic
      # @return [Boolean]
      def failure?
        !success?
      end

      private

      # The result of a Terms enforcement
      #
      # @api private
      # @return [Dry::Validation::Result]
      attr_reader :result
    end
  end
end