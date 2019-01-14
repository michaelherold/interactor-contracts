# frozen_string_literal: true

module Interactor
  module Contracts
    # Base error class used for all errors within the gem.
    ContractsError = Class.new(StandardError)

    # Raised when trying to include Interactor::Contracts into a class that is
    # not an Interactor.
    NotAnInteractor = Class.new(ContractsError)
  end
end
