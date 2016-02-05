require "dry-validation"
require "interactor"

module Interactor
  # Create a contract for your interactor that specifies what it expects as
  # inputs.
  module Contracts
    def self.included(descendant)
      super
      descendant.extend(ClassMethods)
    end

    # Defines the class-level DSL that enables Interactor contracts.
    module ClassMethods
      # The expectations for arguments passed into the Interactor.
      #
      # @!attribute [r] expectations
      #   @return [Dry::Validations::Schema] the expectations schema
      attr_reader :expectations

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
      #       attr(:name, &:filled?)
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
        @expectations ||= Class.new(Dry::Validation::Schema)
        @expectations.instance_exec(&block)

        define_before_hook
      end

      private

      # Defines a before hook that validates the Interactor's input against its
      # contract.
      #
      # @raise [Interactor::Failure] if the input fails to meet its contract.
      # @return [void]
      def define_before_hook
        before do
          expectations = self.class.expectations.new
          result = expectations.call(context)

          unless result.success?
            context.fail!
          end
        end
      end
    end
  end
end
