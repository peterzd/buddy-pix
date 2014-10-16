require "test_helper"

describe User do
  let(:user) { create :user, email: "peter@test.com", password: "11111111" }

  it "must be valid" do
    user.must_be :valid?
  end

  it "has a username" do
    user.username.must_equal "peterzd"
  end

  it "creates a record in DB" do
    user
    User.count.must_equal 1
  end
end
