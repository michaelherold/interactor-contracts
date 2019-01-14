# frozen_string_literal: true

require 'dry-validation'
require 'interactor'
require 'interactor/contracts/dsl'
require 'interactor/contracts/errors'

module Interactor
  # Create a contract for your interactor that specifies what it expects as
  # inputs.
  module Contracts
    # Called when the module is included into another class or module
    #
    # @api private
    # @param [Class, Module] descendant the including class or module
    # @return [void]
    def self.included(descendant)
      unless descendant.include?(Interactor)
        raise NotAnInteractor, "#{descendant} does not include `Interactor'"
      end
      descendant.extend(DSL)
    end

    private

    # The Contract to enforce on calls to the Interactor
    #
    # @api private
    # @return [Contract]
    def contract
      self.class.contract
    end

    # Checks for a breach of contract and applies consequences for a breach
    #
    # @api private
    # @param [#call] contracts a callable object
    # @return [void]
    def enforce_contracts(contracts)
      return unless (outcome = contracts.call(context)).failure?

      contract.consequences.each do |handler|
        instance_exec(outcome.breaches, &handler)
      end
    end
  end
end
