require "test_helper"

describe User do
  let(:user) { create :user, email: "peter@test.com", password: "11111111" }
  let(:album) { create :album, name: "first album", private: false, hidden: false }

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

  describe "joins an album" do
    before do
      user.joins_album(album)
    end

    it "adds the card to the user's joined_albums list" do
      user.joined_albums.must_include album
    end

    it "adds the user to the card's followers list" do
      album.followers.must_include user
    end
  end
end
