require "test_helper"

describe Support do
  let(:support) { Support.new }

  it "must be valid" do
    support.must_be :valid?
  end
end
