# frozen_string_literal: true

require 'readme_parser'
require 'pathname'
require 'English'

RSpec.describe 'Examples' do
  context 'README' do
    subject(:examples) { ReadmeParser.new('README.markdown').fenced_code_blocks }

    it 'there is at least one' do
      expect(examples).to be
      expect(examples.size).to be > 0
    end

    it 'have at least one line' do
      examples.each do |example|
        expect(example.lines.size).to be >= 1
      end
    end

    it 'each one evaluates successfully' do
      examples.each.with_index do |example, i|
        expect { eval(example) }.not_to raise_error, "when evaluating example ##{i + 1}: \n" + example
      end
    end
  end

  context 'examples folder' do
    subject(:examples) { Pathname.glob('examples/*') }

    it 'there is at least one' do
      expect(examples).to be
      expect(examples.size).to be > 0
    end

    it 'each one executes successfully' do
      examples.each do |example_file|
        system(example_file.to_s)
        expect($CHILD_STATUS.success?).to be_truthy, "when evaluating example #{example_file}"
      end
    end
  end
end
