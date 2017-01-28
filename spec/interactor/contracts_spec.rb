require "spec_helper"

RSpec.describe Interactor::Contracts do
  it "raises a NotAnInteractor exception when included in a non-Interactor" do
    expect do
      Class.new do
        include Interactor::Contracts
      end
    end.to raise_error(Interactor::Contracts::NotAnInteractor)
  end

  describe ".assures" do
    it "creates and uses a schema to validate outputs" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        assures do
          required(:name).filled
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
          required(:first_name).filled
        end

        assures do
          required(:last_name).filled
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

    it "only validates the assurances once when defined separately" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        assures do
          required(:first_name).filled
        end

        assures do
          required(:last_name).filled
        end

        def call
          if context.enabled?
            context.first_name = "Billy"
            context.last_name  = "Boyd"
          end
        end
      end

      expect(interactor.after_hooks.size).to eq(1)
    end
  end

  describe ".expects" do
    it "creates and uses a schema to validate inputs" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        expects do
          required(:name).filled
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
          required(:first_name).filled
        end

        expects do
          required(:last_name).filled
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

    it "only validates the expectations once when defined separately" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        expects do
          required(:first_name).filled
        end

        expects do
          required(:last_name).filled
        end
      end

      expect(interactor.before_hooks.size).to eq(1)
    end
  end

  describe ".on_violation" do
    it "replaces the default validation handler" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        expects { required(:name).filled }

        on_violation { |_| context[:message] = "Bilbo Baggins!" }
      end

      result = interactor.call

      expect(result).to be_a_success
      expect(result.message).to eq("Bilbo Baggins!")
    end

    it "handles postcondition violations" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        assures { required(:name).filled }

        on_violation { |_| context[:message] = "Bilbo Baggins!" }
      end

      result = interactor.call

      expect(result).to be_a_success
      expect(result.message).to eq("Bilbo Baggins!")
    end

    it "can be called more than once" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        expects { required(:name).filled }

        on_violation { |_| context[:silly] = "You did something silly." }
        on_violation { |_| context.fail!(:message => "Bilbo Baggins!") }
      end

      result = interactor.call

      expect(result).to be_a_failure
      expect(result.silly).to eq("You did something silly.")
      expect(result.message).to eq("Bilbo Baggins!")
    end

    it "runs handlers in order until there is a failure" do
      interactor = Class.new do
        include Interactor
        include Interactor::Contracts

        expects { required(:name).filled }

        on_violation { |_| context.fail!(:message => "Bilbo Baggins!") }
        on_violation { |_| context[:wont_be_set] = "Nope" }
      end

      result = interactor.call

      expect(result).to be_a_failure
      expect(result.message).to eq("Bilbo Baggins!")
      expect(result.wont_be_set).to be_nil
    end
  end
end
