# frozen_string_literal: true

require 'interactor/contracts/outcome'

module Interactor
  module Contracts
    # The terms of a contract, either for promises or expectations
    class Terms
      # Instantiates a new set of terms
      #
      # @example
      #   terms = Interactor::Contracts::Terms.new
      #
      # @api public
      # @param [Dry::Validation::Contract] terms the terms to start with
      def initialize(terms = Class.new(Dry::Validation::Contract))
        @terms = terms
      end

      # Add a new set of terms to the list of terms
      #
      # @example
      #   terms = Interactor::Contracts::Terms.new
      #   terms.add do
      #     required(:name).filled
      #   end
      #
      # @api public
      # @param [Block] term the term to add to the terms
      # @return [void]
      def add(&term)
        @terms = Class.new(Dry::Validation::Contract).tap do |new_terms|
          new_terms.instance_variable_set(
            :@config,
            @terms.instance_variable_get(:@config).dup
          )
          new_terms.params(@terms.schema, &term)
        end
      end

      # Validates the terms against a given context
      #
      # @example
      #   terms = Interactor::Contracts::Terms.new
      #   terms.add do
      #     required(:name).filled
      #   end
      #   terms.call(:name => "Bilbo Baggins")
      #
      # @api public
      # @param [#to_h] context the context to validate the terms against
      # @return [Outcome]
      def call(context)
        define_empty_schema

        Outcome.new(@terms.new.call(context.to_h))
      end

      # Configures the underlying contracts within the terms
      #
      # @api private
      # @private
      # @return [void]
      def config(&block)
        @terms.config.instance_exec(&block)
      end

      private

      # Defines a no-op schema as a base to extend upon
      #
      # This prevents the raising of a `Dry::Validation::SchemaMissingError`
      # exception.
      #
      # @api private
      # @return [void]
      def define_empty_schema
        @terms.params.nil? && @terms.params {}
      end
    end
  end
end
