require "interactor/contracts/terms"

module Interactor
  module Contracts
    # Contains the assurances, expectations, and consequences of an
    # interactor's contract.
    class Contract
      # Instantiates a new Contract with the given contraints.
      #
      # @param [Terms] assurances the Contract's assurances
      # @param [Terms] expectations the Contract's expectations
      # @param [Array<#call>] consequences the Contract's consequences
      # rubocop:disable Metrics/LineLength
      def initialize(assurances: Terms.new, expectations: Terms.new, consequences: [])
        @assurances = assurances
        @consequences = consequences
        @expectations = expectations
      end

      # The assurances the Contract will fulfill.
      #
      # @return [Terms] the terms for the assurances
      attr_reader :assurances

      # The expectations for arguments passed into the Interactor.
      #
      # @return [Terms] the terms for the expectations
      attr_reader :expectations

      # Adds an assurance to the Contract's set of assurances.
      #
      # @param [Block] term the assurance as a block of arity 0
      # @return [void]
      def add_assurance(&term)
        assurances.add(&term)
      end

      # Adds a consequence to the Contract's set of consequences.
      #
      # @param [#call] consequence the consequence as a callable with arity 1
      # @return [void]
      def add_consequence(consequence)
        @consequences << consequence
      end

      # Adds an expectation to the Contract's set of expectations.
      #
      # @param [Block] term the expectation as a block of arity 0
      # @return [void]
      def add_expectation(&term)
        expectations.add(&term)
      end

      # The consequences for the Contract. When no consequences have been
      # defined, it defaults to an array containing the default consequence.
      #
      # @return [Array<#call>] the consequences for the Contract
      def consequences
        if @consequences.empty?
          Array(default_consequence)
        else
          @consequences
        end
      end

      private

      # The default consequence of a breached contract.
      #
      # @return [#call] the default consequence
      def default_consequence
        ->(_breached_terms) { context.fail! }
      end
    end
  end
end
