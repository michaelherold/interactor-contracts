require "delegate"

module Interactor
  module Contracts
    # A simple wrapper around set of breaches of contract constraints
    class BreachSet < SimpleDelegator
      # Converts the breach set into a Hash for use with context failing
      #
      # @example
      #   class AuthenticateUser
      #     include Interactor
      #     include Interactor::Contracts
      #
      #     expects do
      #       required(:email).filled
      #       required(:password).filled
      #     end
      #
      #     assures do
      #       required(:user).filled
      #       required(:token).filled
      #     end
      #
      #     on_breach do |breaches|
      #       context.fail!(breaches)
      #     end
      #   end
      #
      #   result = AuthenticateUser.call({})
      #   #=> #<Interactor::Context email=["email is missing"],
      #                             password=["password is missing"]>
      #
      #   result.failure?  #=> true
      #
      # @api public
      # @return [Hash] a hash with property keys and message values
      def to_hash
        reduce({}) do |result, (property, messages)|
          result[property] = Array(result[property]) | messages
          result
        end
      end
      alias_method :to_h, :to_hash
    end
  end
end
