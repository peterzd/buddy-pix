require "test_helper"

describe Image do
  helper_objects

  it "must be valid" do
    image.must_be :valid?
  end

end
