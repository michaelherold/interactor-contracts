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
end
