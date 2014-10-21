require "test_helper"

describe Comments do
  let(:comments) { Comments.new }

  it "must be valid" do
    comments.must_be :valid?
  end
end
