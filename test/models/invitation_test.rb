require "test_helper"

describe Invitation do
  let(:invitation) { Invitation.new }

  it "must be valid" do
    invitation.must_be :valid?
  end
end
