require "test_helper"

describe Like do
  let(:like) { Like.new }

  it "must be valid" do
    like.must_be :valid?
  end

end
