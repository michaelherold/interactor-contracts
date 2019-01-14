# frozen_string_literal: true

require 'dry-validation'
require 'interactor/contracts/outcome'

module Interactor
  module Contracts
    # The terms of a contract, either for assurances or expectations
    class Terms
      # Instantiates a new set of terms
      #
      # @example
      #   terms = Interactor::Contracts::Terms.new
      #
      # @api public
      # @param [Dry::Validation::Schema] terms the terms to start with
      def initialize(terms = Class.new(Dry::Validation::Schema))
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
        @terms = Dry::Validation.Schema(@terms, { build: false }, &term)
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
        Outcome.new(@terms.new.call(context.to_h))
      end
    end
  end
end
