RSpec.describe Stubbornly do
  it "has a version number" do
    expect(Stubbornly::VERSION).not_to be nil
  end

  it "executes the block" do
    result = subject.retry do
      'success'
    end

    expect(result).to eq('success')
  end
end
