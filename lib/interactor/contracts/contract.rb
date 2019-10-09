# frozen_string_literal: true

require 'interactor/contracts/terms'

module Interactor
  module Contracts
    # Contains the promises, expectations, and consequences of an
    # interactor's contract.
    class Contract
      # Instantiates a new Contract with the given constraints
      #
      # @example
      #   Interactor::Contracts::Contract.new
      #
      # @api semipublic
      # @param [Terms] promises the Contract's promises
      # @param [Terms] expectations the Contract's expectations
      # @param [Array<#call>] consequences the Contract's consequences
      # rubocop:disable Metrics/LineLength
      def initialize(promises: Terms.new, expectations: Terms.new, consequences: [])
        @promises = promises
        @consequences = consequences
        @expectations = expectations
      end
      # rubocop:enable Metrics/LineLength

      # The promises the Contract will fulfill
      #
      # @example
      #   contract = Interactor::Contracts::Contract.new
      #   contract.promises  #=> <#Interactor::Contracts::Terms>
      #
      # @api semipublic
      # @return [Terms] the terms for the promises
      attr_reader :promises

      # The expectations for arguments passed into the Interactor
      #
      # @example
      #   contract = Interactor::Contracts::Contract.new
      #   contract.expectations  #=> <#Interactor::Contracts::Terms>
      #
      # @api semipublic
      # @return [Terms] the terms for the expectations
      attr_reader :expectations

      # Adds an promise to the Contract's set of promises
      #
      # @example
      #   contract = Interactor::Contracts::Contract.new
      #   contract.add_promise do
      #     required(:name).filled
      #   end
      #
      # @api semipublic
      # @param [Block] term the promise as a block of arity 0
      # @return [void]
      def add_promise(&term)
        promises.add(&term)
      end

      # Adds a consequence to the Contract's set of consequences
      #
      # @example
      #   contract = Interactor::Contracts::Contract.new
      #   contract.add_expectation do |breaches|
      #     context[:message] = breaches.first.messages.first
      #   end
      #
      # @api semipublic
      # @param [#call] consequence the consequence as a callable with arity 1
      # @return [void]
      def add_consequence(consequence)
        @consequences << consequence
      end

      # Adds an expectation to the Contract's set of expectations
      #
      # @example
      #   contract = Interactor::Contracts::Contract.new
      #   contract.add_expectation do
      #     required(:name).filled
      #   end
      #
      # @api semipublic
      # @param [Block] term the expectation as a block of arity 0
      # @return [void]
      def add_expectation(&term)
        expectations.add(&term)
      end

      # Configures the underlying contracts for the validation schemata
      #
      # @api private
      # @private
      # @return [void]
      def config(&block)
        promises.config(&block)
        expectations.config(&block)
      end

      # The consequences for the Contract
      #
      # @example
      #   contract = Interactor::Contracts::Contract.new
      #   contract.consequences  #=> [<#Proc>]
      #
      # @api semipublic
      # @return [Array<#call>] the consequences for the Contract
      def consequences
        if @consequences.empty?
          Array(default_consequence)
        else
          @consequences
        end
      end

      private

      # The default consequence of a breached contract
      #
      # @api private
      # @return [#call] the default consequence
      def default_consequence
        ->(breaches) { context.fail!(breaches) }
      end
    end
  end
end
