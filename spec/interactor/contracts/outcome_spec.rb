# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactor::Contracts::Outcome do
  describe '#breaches' do
    subject { described_class.new(result).breaches }

    context 'for a successful result' do
      let(:result) { successful_result }

      it { is_expected.to eq([]) }

      it 'converts to an empty hash' do
        expect(subject.to_h).to eq({})
      end
    end

    context 'for an unsuccessful result' do
      let(:result) { unsuccessful_result }

      it 'has a breach for every failed validation' do
        expect(subject.size).to eq(1)
        breach = subject.first
        expect(breach.messages).to eq(['name is missing'])
        expect(breach.property).to eq(:name)
      end

      it 'converts to a hash based on its breaches' do
        expect(subject.to_h).to eq(name: ['name is missing'])
      end
    end
  end

  describe '#failure?' do
    subject { described_class.new(result).failure? }

    context 'for a successful result' do
      let(:result) { successful_result }

      it { is_expected.to eq(false) }
    end

    context 'for an unsuccessful result' do
      let(:result) { unsuccessful_result }

      it { is_expected.to eq(true) }
    end
  end

  describe '#success?' do
    subject { described_class.new(result).success? }

    context 'for a successful result' do
      let(:result) { successful_result }

      it { is_expected.to eq(true) }
    end

    context 'for an unsuccessful result' do
      let(:result) { unsuccessful_result }

      it { is_expected.to eq(false) }
    end
  end

  def schema
    Dry::Validation.Schema do
      required(:name).filled
    end
  end

  def successful_result
    schema.call(name: 'Bilbo Baggins')
  end

  def unsuccessful_result
    schema.call({})
  end
end
