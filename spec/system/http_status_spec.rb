# frozen_string_literal: true

require 'pathname'
require 'English'

RSpec.describe 'http_status' do
  subject { 'examples/http_status' }

  it 'exists' do
    expect(Pathname(subject)).to exist
  end

  it 'executes successfully' do
    system(subject)
    expect($CHILD_STATUS.success?).to be_truthy, "when evaluating example #{subject}"
  end
end
