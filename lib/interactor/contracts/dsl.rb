# frozen_string_literal: true

require 'interactor/contracts/contract'

module Interactor
  module Contracts
    # Defines the class-level DSL that enables Interactor contracts.
    module DSL
      # Defines the promises of an Interactor and creates an after hook
      #
      # @example
      #   class CreatePerson
      #     include Interactor
      #     include Interactor::Contracts
      #
      #     promises do
      #       required(:person).filled
      #     end
      #
      #     def call
      #       context.person = Person.new
      #     end
      #   end
      #
      # @api public
      # @param [Block] block the block defining the promises
      # @return [void]
      def promises(&block)
        contract.add_promise(&block)
        define_promises_hook
      end
      alias assures promises

      # The Contract to enforce on calls to the Interactor
      #
      # @example
      #   class CreatePerson
      #     include Interactor
      #     include Interactor::Contracts
      #
      #     promises do
      #       required(:person).filled
      #     end
      #
      #     contracts  #=> <#Interactor::Contracts::Contract>
      #   end
      #
      # @api semipublic
      # @return [Contract]
      def contract
        @contract ||= Contract.new
      end

      # Defines the expectations of an Interactor and creates a before hook
      #
      # @example
      #   class CreatePerson
      #     include Interactor
      #     include Interactor::Contracts
      #
      #     expects do
      #       required(:name).filled
      #     end
      #
      #     def call
      #       context.person = Person.create!(:name => context.name)
      #     end
      #   end
      #
      #   CreatePerson.call(:first_name => "Billy").success?  #=> false
      #   CreatePerson.call(:name => "Billy").success?        #=> true
      #
      # @api public
      # @param [Block] block the block defining the expectations
      # @return [void]
      def expects(&block)
        contract.add_expectation(&block)
        define_expectations_hook
      end

      # Sets contract to given one and calls hooks
      # define_promises_hook and define_expectations_hook
      #
      # @api semipublic
      # @param [Contract] contract
      # @return [void]
      def inherit_contract(contract)
        @contract = Contract.new(
          promises: contract.promises.clone,
          expectations: contract.expectations.clone,
          consequences: contract.consequences.clone
        )
        define_promises_hook
        define_expectations_hook
      end

      # Defines a consequence that is called when a contract is breached
      #
      # @example
      #   class CreatePerson
      #     include Interactor
      #     include Interactor::Contracts
      #
      #     expects do
      #       required(:name).filled
      #     end
      #
      #     on_breach do |breaches|
      #       context.fail!(:message => "invalid_#{breaches.first.property}")
      #     end
      #
      #     def call
      #       context.person = Person.create!(:name => context.name)
      #     end
      #   end
      #
      #   CreatePerson.call(:first_name => "Billy").message  #=> "invalid_name"
      #
      # @api public
      # @param [Block] block the consequence as a block of arity 1.
      # @return [void]
      def on_breach(&block)
        contract.add_consequence(block)
      end

      private

      # Flags whether the promises hook has been defined
      #
      # @api private
      # @return [TrueClass, FalseClass] true if the hook is defined
      attr_reader :defined_promises_hook
      alias defined_promises_hook? defined_promises_hook

      # Flags whether the expectations hook has been defined
      #
      # @api private
      # @return [TrueClass, FalseClass] true if the hook is defined
      attr_reader :defined_expectations_hook
      alias defined_expectations_hook? defined_expectations_hook

      # Defines an after hook that validates the Interactor's output
      #
      # @api private
      # @raise [Interactor::Failure] if the input fails to meet its contract.
      # @return [void]
      def define_promises_hook
        return if defined_promises_hook?

        after { enforce_contracts(contract.promises) }

        @defined_promises_hook = true
      end

      # Defines a before hook that validates the Interactor's input
      #
      # @api private
      # @raise [Interactor::Failure] if the input fails to meet its contract.
      # @return [void]
      def define_expectations_hook
        return if defined_expectations_hook?

        before { enforce_contracts(contract.expectations) }

        @defined_expectations_hook = true
      end

      # Defines a callback for class inheritance
      #
      # @api private
      # @param [Class] child a child of inherited class
      # @return [void]
      def inherited(child)
        child.inherit_contract(contract)
      end
    end
  end
end
