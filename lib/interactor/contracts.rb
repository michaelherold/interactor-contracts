require "dry-validation"
require "interactor"
require "interactor/contracts/dsl"
require "interactor/contracts/errors"

module Interactor
  # Create a contract for your interactor that specifies what it expects as
  # inputs.
  module Contracts
    # Called when the module is included into another class or module.
    #
    # @private
    # @param [Class, Module] descendant the including class or module
    def self.included(descendant)
      unless descendant.ancestors.include?(Interactor)
        fail NotAnInteractor, "#{descendant} does not include `Interactor'"
      end
      descendant.extend(DSL)
    end

    private

    # The Contract to enforce on calls to the Interactor.
    #
    # @return [Contract]
    def contract
      self.class.contract
    end

    # Checks for a breach of contracts against the context's data and applies
    # the consequences if there is a breach.
    #
    # @private
    # @param [#call] contracts a callable object
    # @return [void]
    def enforce_contracts(contracts)
      outcome = contracts.call(context)

      unless outcome.success?
        contract.consequences.each do |handler|
          instance_exec(outcome.breaches, &handler)
        end
      end
    end
  end
end
