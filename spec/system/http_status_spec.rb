# frozen_string_literal: true

require 'pathname'
require 'English'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'http_status' do
  subject(:example) { 'examples/http_status' }

  it 'exists' do
    expect(Pathname(example)).to exist
  end

  it 'executes successfully' do
    system(example)
    expect($CHILD_STATUS.success?).to be_truthy, "when evaluating example #{example}"
  end
end
# rubocop:enable RSpec/DescribeClass
