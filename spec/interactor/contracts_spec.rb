require "spec_helper"

RSpec.describe Interactor::Contracts do
  describe ".assures" do
    it "creates and uses a schema to validate outputs" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        assures do
          attr(:name, &:filled?)
        end

        def call
          if context.enabled?
            context.name = "Billy"
          end
        end
      end

      expect(interactor.call(:enabled? => true)).to be_a_success
      expect(interactor.call(:enabled? => false)).to be_a_failure
    end

    it "can be called more than once" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        assures do
          attr(:first_name, &:filled?)
        end

        assures do
          attr(:last_name, &:filled?)
        end

        def call
          if context.enabled?
            context.first_name = "Billy"
            context.last_name  = "Boyd"
          end
        end
      end

      expect(interactor.call(:enabled? => true)).to be_a_success
      expect(interactor.call(:enabled? => false)).to be_a_failure
    end
  end

  describe ".expects" do
    it "creates and uses a schema to validate inputs" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        expects do
          attr(:name, &:filled?)
        end
      end

      expect(interactor.call(:name => "Billy")).to be_a_success
      expect(interactor.call(:first_name => "Billy")).to be_a_failure
    end

    it "can be called more than once" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        expects do
          attr(:first_name, &:filled?)
        end

        expects do
          attr(:last_name, &:filled?)
        end
      end

      expect(
        interactor.call(
          :first_name => "Billy",
          :last_name => "Boyd"
        )
      ).to be_a_success
      expect(interactor.call(:first_name => "Billy")).to be_a_failure
    end
  end
end
