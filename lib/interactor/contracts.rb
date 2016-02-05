require "dry-validation"
require "interactor"

# :nodoc:
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

      # The assurances the Interactor will fulfill.
      #
      # @!attribute [r] assurances
      #   @return [Dry::Validations::Schema] the assurances schema
      attr_reader :assurances

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
      #       attr(:person, &:filled?)
      #     end
      #
      #     def call
      #       context.person = Person.new
      #     end
      #   end
      # @param [Block] block the block defining the assurances
      # @return [void]
      def assures(&block)
        @assurances ||= Class.new(Dry::Validation::Schema)
        @assurances.instance_exec(&block)

        define_after_hook
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

      # Defines an after hook that validates the Interactor's output against
      # its contract.
      #
      # @raise [Interactor::Failure] if the input fails to meet its contract.
      # @return [void]
      def define_after_hook
        after do
          assurances = self.class.assurances.new
          result = assurances.call(context)

          unless result.success?
            context.fail!
          end
        end
      end

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
