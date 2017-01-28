require "spec_helper"

RSpec.describe Interactor::Contracts::Terms do
  it "can have multiple terms added to it" do
    terms = described_class.new
    terms.add do
      required(:title).filled
    end
    terms.add do
      required(:author).filled
    end

    outcome = terms.call({})

    expect(outcome).not_to be_a_success
    expect(outcome.breaches.size).to eq(2)

    outcome = terms.call(
      :title => "There and Back Again",
      :author => "Bilbo Baggins"
    )

    expect(outcome).to be_a_success
    expect(outcome.breaches.size).to eq(0)
  end

  it "is a success when there are no constraints" do
    terms = described_class.new

    expect(terms.call({})).to be_a_success
  end
end
