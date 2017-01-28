require "dry-validation"
require "interactor/contracts/outcome"

module Interactor
  module Contracts
    class Terms
      def initialize(terms = Class.new(::Dry::Validation::Schema))
        @terms = terms
      end

      def add(&term)
        @terms = ::Dry::Validation.Schema(@terms, {:build => false}, &term)
      end

      def call(context)
        Outcome.new(@terms.new.call(context.to_h))
      end
    end
  end
end
