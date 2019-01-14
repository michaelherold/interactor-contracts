# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactor::Contracts::Breach do
  describe '#to_ary' do
    it 'allows you to splat the breach as a block argument' do
      breach = described_class.new(:name, ['Bilbo Baggins'])

      expect(breach.to_ary).to eq([:name, ['Bilbo Baggins']])
      breach.tap do |property, messages|
        expect(property).to eq(:name)
        expect(messages).to eq(['Bilbo Baggins'])
      end
    end
  end

  describe '#to_h' do
    it 'takes the property as a key and the messages as its value' do
      breach = described_class.new(:name, ['Bilbo Baggins'])

      expect(breach.to_h).to eq(name: ['Bilbo Baggins'])
    end
  end
end
