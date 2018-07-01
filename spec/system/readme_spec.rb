# frozen_string_literal: true

require 'readme_parser'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'README.markdown' do
  subject(:examples) { ReadmeParser.new('README.markdown').fenced_code_blocks }

  it 'there is at least one example' do
    expect(examples.size).to be > 0
  end

  it 'each one has at least one line' do
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
# rubocop:enable RSpec/DescribeClass
