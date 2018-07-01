# frozen_string_literal: true

require 'logger'
require 'null_logger'
require 'limiter'
require 'stubbornly/version'

RSpec.describe Stubbornly do
  context 'without block' do
    subject(:stubbornly) { described_class.new(logger: logger) }

    let(:logger) { NullLogger.new }
    # let(:logger) { Logger.new(STDERR) } # Enable this one if you need verbose logging

    it 'has a version number' do
      expect(Stubbornly::VERSION).not_to be nil
    end

    describe '#retry' do
      it 'does nothing without a block' do
        expect { stubbornly.retry }.not_to raise_error
      end

      it 'executes the block' do
        has_been_called = false

        stubbornly.retry do
          has_been_called = true
        end

        expect(has_been_called).to be_truthy
      end

      it "returns the block's result" do
        result = stubbornly.retry do
          'success'
        end

        expect(result).to eq('success')
      end

      context 'with default parameters' do
        countdown = 4
        let(:limiter) { Limiter.new(1) }

        it 'keeps executing the block until it succeeds' do
          stubbornly.retry do
            countdown -= 1
            limiter.limit(countdown)
          end

          expect(countdown).to eq(1)
        end
      end

      it 'executes the block at least the given number of times'
      it "raises the block's error"
      it 'yields the elapsed time to the block'
      it 'yields the attempt to the block'
    end

    context 'with a block' do
      it 'accepts a block for the backoff algorithm' do
        with_block = described_class.new do
          described_class.new { 0.1 }
        end

        expect { with_block.retry }.not_to raise_error
      end
    end
  end
end
