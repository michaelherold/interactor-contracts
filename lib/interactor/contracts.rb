require "dry-validation"
require "interactor"
require "interactor/contracts/errors"
require "interactor/contracts/violation"

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
      descendant.extend(ClassMethods)
    end

    # Defines the class-level DSL that enables Interactor contracts.
    module ClassMethods
      # The assurances the Interactor will fulfill.
      #
      # @return [Dry::Validations::Schema] the assurances schema
      def assurances
        @assurances ||= Class.new(Dry::Validation::Schema)
      end

      # Defines the assurances of an Interactor and creates an after hook to
      # validate the output when called.
      #
      # @example
      #
      #   class CreatePerson
      #     include Interactor
      #     include Interactor::Contracts
      #
      #     assures do
      #       required(:person).filled
      #     end
      #
      #     def call
      #       context.person = Person.new
      #     end
      #   end
      # @param [Block] block the block defining the assurances
      # @return [void]
      def assures(&block)
        self.assurances = extend_schema(assurances, &block)
        define_assurances_hook
      end

      # The default violation handler that fails the context.
      #
      # @return [Proc] the default violation handler
      def default_violation_handler
        ->(_violations) { context.fail! }
      end

      # Defines the expectations of an Interactor and creates a before hook to
      # validate the input when called.
      #
      # @example
      #
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
      # @param [Block] block the block defining the expectations
      # @return [void]
      def expects(&block)
        self.expectations = extend_schema(expectations, &block)
        define_expectations_hook
      end

      # The expectations for arguments passed into the Interactor.
      #
      # @return [Dry::Validations::Schema] the expectations schema
      def expectations
        @expectations ||= Class.new(Dry::Validation::Schema)
      end

      # Defines a violation handler that is called when a contract is violated.
      #
      # @example
      #
      #   class CreatePerson
      #     include Interactor
      #     include Interactor::Contracts
      #
      #     expects do
      #       required(:name).filled
      #     end
      #
      #     on_violation do |violations|
      #       context.fail!(:message => "invalid_#{violations.first.property}")
      #     end
      #
      #     def call
      #       context.person = Person.create!(:name => context.name)
      #     end
      #   end
      #
      #   CreatePerson.call(:first_name => "Billy").message  #=> "invalid_name"
      #
      # @param [Block] block the validation handler as a block of arity 1.
      # @return [void]
      def on_violation(&block)
        defined_violation_handlers << block
      end

      # The violation handlers for the contract. When no custom violation
      # handlers have been defined, it defaults to an array containing the
      # default violation handler.
      #
      # @return [Array<Proc>] the violation handlers for the contract
      def violation_handlers
        if defined_violation_handlers.empty?
          Array(default_violation_handler)
        else
          defined_violation_handlers
        end
      end

      private

      attr_writer :assurances
      attr_writer :expectations

      # Flags whether the assurances hook has been defined.
      #
      # @!attribute [r] defined_assurances_hook
      #   @return [TrueClass, FalseClass] true if the hook is defined
      attr_reader :defined_assurances_hook
      alias_method :defined_assurances_hook?, :defined_assurances_hook

      # Flags whether the expectations hook has been defined.
      #
      # @!attribute [r] defined_assurances_hook
      #   @return [TrueClass, FalseClass] true if the hook is defined
      attr_reader :defined_expectations_hook
      alias_method :defined_expectations_hook?, :defined_expectations_hook

      # Defines an after hook that validates the Interactor's output against
      # its contract.
      #
      # @raise [Interactor::Failure] if the input fails to meet its contract.
      # @return [void]
      def define_assurances_hook
        return if defined_assurances_hook?

        after do
          assurances = self.class.assurances.new
          result = assurances.call(context.to_h)

          unless result.success?
            violations = result.messages.map do |property, messages|
              Violation.new(property, messages)
            end
            self.class.violation_handlers.each do |handler|
              instance_exec(violations, &handler)
            end
          end
        end

        @defined_assurances_hook = true
      end

      # Defines a before hook that validates the Interactor's input against its
      # contract.
      #
      # @raise [Interactor::Failure] if the input fails to meet its contract.
      # @return [void]
      def define_expectations_hook
        return if defined_expectations_hook?

        before do
          expectations = self.class.expectations.new
          result = expectations.call(context.to_h)

          unless result.success?
            violations = result.messages.map do |property, messages|
              Violation.new(property, messages)
            end
            self.class.violation_handlers.each do |handler|
              instance_exec(violations, &handler)
            end
          end
        end

        @defined_expectations_hook = true
      end

      # The custom violation handlers defined for the contract.
      #
      # @return [Array<Proc>] the custom validation handlers for the contract
      def defined_violation_handlers
        @defined_violation_handlers ||= []
      end

      def extend_schema(schema = Dry::Validation::Schema, &block)
        Dry::Validation.Schema(schema, {:build => false}, &block)
      end
    end
  end
end
