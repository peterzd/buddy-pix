require "test_helper"

describe Tagging do
  let(:tagging) { Tagging.new }

  it "must be valid" do
    tagging.must_be :valid?
  end
end
