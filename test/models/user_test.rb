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

  describe "relations with profile image" do
    it "cteates the image and set it as the user's profile image" do
      image = create :image
      user.set_profile_cover image
      user.profile_cover.must_equal image
      image.covered_user.must_equal user
    end

    it "only can has one profile image" do
      image_1 = create :image
      image_2 = create :image
      user.set_profile_cover image_1
      user.set_profile_cover image_2

      user.profile_cover.must_equal image_2
    end

    it "adds the image into the user's cover_images" do
      image = create :image
      user.set_profile_cover image
      user.cover_images.must_include image
    end
  end
end
