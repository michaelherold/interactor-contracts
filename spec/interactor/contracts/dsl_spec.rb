# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactor::Contracts::DSL do
  describe '.expects' do
    subject(:interactor_call) { klass.call(context) }
    let(:parent) do
      Class.new do
        include Interactor
        include Interactor::Contracts

        expects do
          required(:bar).filled
        end

        on_breach do |breaches|
          context.fail!(message: breaches.to_h)
        end
      end
    end

    let(:child) do
      Class.new(parent) do
      end
    end

    let(:context) { { bar: '' } }

    context 'when parent class' do
      let(:klass) { parent }

      it 'validates input' do
        expect(interactor_call).to be_a_failure
        expect(interactor_call.message).to eq(bar: ['bar must be filled'])
      end
    end

    context 'when child class' do
      let(:klass) { child }

      it 'validates input' do
        expect(interactor_call).to be_a_failure
        expect(interactor_call.message).to eq(bar: ['bar must be filled'])
      end
    end
  end

  describe '.assures' do
    subject(:interactor_call) { klass.call(context) }
    let(:parent) do
      Class.new do
        include Interactor
        include Interactor::Contracts

        assures do
          required(:bar).filled
        end

        on_breach do |breaches|
          context.fail!(message: breaches.to_h)
        end
      end
    end

    let(:child) do
      Class.new(parent) do
      end
    end

    let(:context) { {} }

    context 'when parent class' do
      let(:klass) { parent }

      it 'validates output' do
        expect(interactor_call).to be_a_failure
        expect(interactor_call.message).to eq(bar: ['bar is missing'])
      end
    end

    context 'when child class' do
      let(:klass) { child }

      it 'validates output' do
        expect(interactor_call).to be_a_failure
        expect(interactor_call.message).to eq(bar: ['bar is missing'])
      end
    end
  end
end
