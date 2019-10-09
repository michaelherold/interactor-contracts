# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactor::Contracts::DSL do
  describe '.config' do
    it 'allows you to configure the messaging for the contracts' do
      require 'i18n'
      require 'dry/schema/messages/i18n'

      klass = Class.new do
        include Interactor
        include Interactor::Contracts

        config do
          messages.backend = :i18n
          messages.top_namespace = :my_app
          messages.load_paths << File.expand_path(
            File.join('..', '..', 'support', 'errors.yml'),
            __dir__
          )
        end

        expects do
          required(:bar).filled
        end

        on_breach do |breaches|
          context.fail!(message: breaches.to_h)
        end
      end

      result = klass.call

      expect(result).to be_a_failure
      expect(result.message).to eq(bar: ['bar is foobared'])
    end
  end

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

    let!(:child) do
      Class.new(parent)
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

    context 'when more than one child' do
      let!(:child) do
        Class.new(parent) do
          expects do
            required(:foo).filled
          end
        end
      end

      let!(:other_child) do
        Class.new(parent) do
          expects do
            required(:buzz).filled
          end
        end
      end

      context 'when parent class' do
        let(:klass) { parent }

        it 'validates output' do
          expect(interactor_call).to be_a_failure
          expect(interactor_call.message).to eq(bar: ['bar must be filled'])
        end
      end

      context 'when child class' do
        let(:klass) { child }

        it 'validates output' do
          expect(interactor_call).to be_a_failure
          expect(interactor_call.message).to eq(
            bar: ['bar must be filled'],
            foo: ['foo is missing']
          )
        end
      end

      context 'when other child class' do
        let(:klass) { other_child }

        it 'validates output' do
          expect(interactor_call).to be_a_failure
          expect(interactor_call.message).to eq(
            bar: ['bar must be filled'],
            buzz: ['buzz is missing']
          )
        end
      end
    end
  end

  describe '.assures (backwards compatibility)' do
    let(:klass) do
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

    subject { klass.call({}) }

    it 'validates the output' do
      expect(subject).to be_a_failure
      expect(subject.message).to eq(bar: ['bar is missing'])
    end
  end

  describe '.promises' do
    subject(:interactor_call) { klass.call(context) }

    let(:parent) do
      Class.new do
        include Interactor
        include Interactor::Contracts

        promises do
          required(:bar).filled
        end

        on_breach do |breaches|
          context.fail!(message: breaches.to_h)
        end
      end
    end

    let!(:child) do
      Class.new(parent)
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

    context 'when more than one child' do
      let!(:child) do
        Class.new(parent) do
          promises do
            required(:foo).filled
          end
        end
      end

      let!(:other_child) do
        Class.new(parent) do
          promises do
            required(:buzz).filled
          end
        end
      end

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
          expect(interactor_call.message).to eq(
            bar: ['bar is missing'],
            foo: ['foo is missing']
          )
        end
      end

      context 'when other child class' do
        let(:klass) { other_child }

        it 'validates output' do
          expect(interactor_call).to be_a_failure
          expect(interactor_call.message).to eq(
            bar: ['bar is missing'],
            buzz: ['buzz is missing']
          )
        end
      end
    end
  end
end
