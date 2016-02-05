require "spec_helper"

RSpec.describe Interactor::Contracts do
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
  end

  describe ".promises" do
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
  end
end
