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
      photo.images << image
    end

    it "must have an image" do
      photo.images.must_include image
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

    it "removes out from the album if destroyed" do
      photo.destroy
      album.photos.wont_include photo
    end
  end

  describe "relations with likes" do
    it "liers can not be duplicated" do
      photo.update album: album
      allen.like_photo photo
      allen.like_photo photo
      photo.likes.count.must_equal 1
      photo.likers.count.must_equal 1
    end

    describe "user likes an image" do
      before do
        photo.update album: album
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

  describe ".tag_user" do
    before do
      photo.tag_user peter
      photo.tag_user allen
    end

    it "adds the user to the photo's tagged_users list" do
      photo.tagged_users.must_match_array [peter, allen]
    end

    it "sends notification to the tagged users" do
      peter_noti = peter.notifications.last
      peter_noti.maker.must_equal nil
      peter_noti.action.must_equal Notification::ACTION[:tagged]
      peter_noti.object.must_equal photo
      peter_noti.receiver.must_equal peter

      allen_noti = allen.notifications.last
      allen_noti.maker.must_equal nil
      allen_noti.action.must_equal Notification::ACTION[:tagged]
      allen_noti.object.must_equal photo
      allen_noti.receiver.must_equal allen
    end
  end
end
