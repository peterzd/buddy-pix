require "test_helper"

describe Photo do
  helper_objects

  describe "relations with album" do
    it "updates the album's created_at time when creates a new photo" do
      photo = album.photos.create title: "newly created", description: "will touch album"
      album.updated_at.to_s.must_equal photo.created_at.to_s
    end
  end

  describe "relations with image" do
    before do
      photo.image = image
    end

    it "must have an image" do
      photo.image.must_equal image
    end

    it "the image should belong to the photo" do
      image.imageable.must_equal photo
    end
  end

  describe "relations with albums" do
    before do
      photo.update album_id: album.id
    end

    it "must belongs to a card" do
      photo.album.must_equal album
    end

    it "the album should have the photo" do
      album.photos.must_include photo
    end
  end

  describe "relations with likes" do
    describe "user likes an image" do
      before do
        peter.like_photo photo, mood: Like::MOOD[:cool]
      end

      it "adds a record to the image's likers list" do
        photo.likers.must_include peter
      end

      it "sets the mood to the like" do
        photo.likes.last.mood.must_equal Like::MOOD[:cool]
      end
    end
  end
end
