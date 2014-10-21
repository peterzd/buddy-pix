require "test_helper"

describe User do
  let(:peter) { create :user, email: "peter@test.com", password: "11111111", first_name: "peter", last_name: "zhao" }
  let(:album) { create :album, name: "first album", private: false, hidden: false }
  let(:image) { create :image }

  it "must be valid" do
    peter.must_be :valid?
  end

  it "has a username" do
    peter.username.must_equal "peterzd"
  end

  it "creates a record in DB" do
    peter
    User.count.must_equal 1
  end

  describe "joins an album" do
    before do
      peter.joins_album(album)
    end

    it "adds the card to the user's joined_albums list" do
      peter.joined_albums.must_include album
    end

    it "adds the user to the card's followers list" do
      album.followers.must_include peter
    end
  end

  describe "relations with profile image" do
    it "creates the image and set it as the user's profile image" do
      image = create :image
      peter.set_profile_cover image
      peter.profile_cover.must_equal image
      image.covered_user.must_equal peter
    end

    it "only can has one profile image" do
      image_1 = create :image
      image_2 = create :image
      peter.set_profile_cover image_1
      peter.set_profile_cover image_2

      peter.profile_cover.must_equal image_2
    end

    it "adds the image into the user's cover_images" do
      image = create :image
      peter.set_profile_cover image
      peter.cover_images.must_include image
    end
  end

  describe "relations with comments" do

  end

  describe "relations with likes" do
    describe "user likes an image" do
      before do
        peter.like_image image, mood: Like::MOOD[:cool]
      end

      it "adds a record to the user's liked_images list" do
        peter.liked_images.must_include image
      end

      it "sets the mood to the like" do
        Like.count.must_equal 1
        peter.likes.last.mood.must_equal Like::MOOD[:cool]
      end
    end
  end
end
