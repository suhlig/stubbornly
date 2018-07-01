# frozen_string_literal: true

require 'logger'
require 'limiter'
require 'stubbornly/version'

RSpec.describe Stubbornly do
  it 'has a version number' do
    expect(Stubbornly::VERSION).not_to be nil
  end

  describe '#retry' do
    it 'does nothing without a block' do
      expect { subject.retry }.to_not raise_error
    end

    it 'executes the block' do
      has_been_called = false

      subject.retry do
        has_been_called = true
      end

      expect(has_been_called).to be_truthy
    end

    it "returns the block's result" do
      result = subject.retry do
        'success'
      end

      expect(result).to eq('success')
    end

    context 'with default parameters' do
      it 'keeps executing the block until it succeeds' do
        limiter = Limiter.new(1)
        countdown = 4

        subject.retry do
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

    it 'accepts a block for the backoff algorithm' do
      subject do
        described_class.new { 0.1 }
      end

      expect { subject.retry }.to_not raise_error
    end
  end
end
