require "test_helper"

describe User do
  helper_objects

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

  describe ".admin?" do
    it "returns true if the user is AdminUser" do
      admin.must_be :admin?
    end

    it "returns false is the user is not an AdminUser" do
      peter.wont_be :admin?
    end
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

  describe ".hidden_cards" do
    it "lists all the user's hidden cards" do
      cards = create_list :album, 5, creator: peter, hidden: false
      hidden_cards = create_list :album, 5, creator: peter, hidden: true
      peter.hidden_cards.must_match_array hidden_cards
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
        peter.like_photo photo, mood: Like::MOOD[:cool]
      end

      it "adds a record to the user's liked_images list" do
        peter.liked_photos.must_include photo
      end

      it "sets the mood to the like" do
        Like.count.must_equal 1
        peter.likes.last.mood.must_equal Like::MOOD[:cool]
      end
    end
  end

  describe ".set_cover_photo" do
    before do
      peter.set_cover_photo image
    end

    it "sets the image as the user's cover photo" do
      peter.cover_photo.must_equal image
    end

    it "adds the image to the user's cover_images list" do
      peter.cover_images.must_include image
    end
  end

  describe ".show_name" do
    describe "not set first_name and last_name yet" do
      it "shows the user's email as the show name" do
        user = create :user, email: "test@test.com", password: "password"
        user.show_name.must_equal "test@test.com"
      end
    end

    describe "has first_name and last_name" do
      it "show's the user's first_name as show_name" do
        peter.show_name.must_equal "peter"
      end
    end
  end

  describe ".total_photos" do
    before do
      @photo_2 = create :photo
      album.photos << [photo, @photo_2]
    end

    it "returns all photos belongs to the albums which the user created" do
      album.update creator: peter
      peter.total_photos.must_match_array [photo, @photo_2]
    end

    it "returns 0 if the user has no created albums" do
      peter.total_photos.must_match_array []
      peter.total_photos.count.must_equal 0
    end
  end
end
