require 'readme_parser'

RSpec.describe 'README.markdown' do
  subject(:examples) { ReadmeParser.new('README.markdown').fenced_code_blocks }

  it "has at least one example" do
    expect(examples).to be
    expect(examples.size).to be > 0
  end

  describe 'first example' do
    subject(:example) { examples.first }

    it 'has multiple lines' do
      expect(example.lines.size).to be > 10
    end

    it 'can be evaluated' do
      expect{ eval(example) }.not_to raise_error
    end
  end
end
