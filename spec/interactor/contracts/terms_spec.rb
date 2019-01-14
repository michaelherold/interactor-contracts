# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactor::Contracts::Terms do
  it 'can have multiple terms added to it' do
    terms = described_class.new
    terms.add do
      required(:title).filled
    end
    terms.add do
      required(:author).filled
    end

    outcome = terms.call({})

    expect(outcome).not_to be_a_success
    expect(outcome).to be_a_failure
    expect(outcome.breaches.size).to eq(2)

    outcome = terms.call(
      title: 'There and Back Again',
      author: 'Bilbo Baggins'
    )

    expect(outcome).to be_a_success
    expect(outcome).not_to be_a_failure
    expect(outcome.breaches.size).to eq(0)
  end

  it 'is a success when there are no constraints' do
    terms = described_class.new

    outcome = terms.call({})

    expect(outcome).to be_a_success
    expect(outcome.breaches).to be_empty
  end

  it 'can take an existing schema as an argument' do
    terms = described_class.new(schema)

    expect(terms.call({})).to be_a_failure
  end

  it 'works with an Interactor::Context' do
    terms = described_class.new
    terms.add do
      required(:name).filled
    end

    outcome = terms.call(Interactor::Context.new(name: 'Bilbo Baggins'))

    expect(outcome).to be_a_success
    expect(outcome.breaches).to be_empty
  end

  def schema
    base = Class.new(Dry::Validation::Schema)
    Dry::Validation.Schema(base, build: false) do
      required(:name).filled
    end
  end
end
