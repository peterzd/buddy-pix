require "test_helper"

describe Album do
  helper_objects

  it "creates two record in DB" do
    [private_album, public_album]
    Album.count.must_equal 2
  end

  it "tells if an album is pirvate or public" do
    private_album.must_be :private?
    public_album.wont_be :private?
  end

  it "followers will have the creator" do
    album
    peter.joined_albums.must_include album
    album.followers.must_include peter
  end

  it "followers can not be duplicated" do
    allen.joins_album album
    allen.joins_album album
    peter.joins_album album

    album.followers.count.must_equal 2
  end

  describe ".joined_by(user)" do
    it "creates a notification to the creator" do
      [album, allen, peter]
      album.joined_by allen
      notification = Notification.first
      notification.maker.must_equal allen
      notification.action.must_equal Notification::ACTION[:join_card]
      notification.object.must_equal album
      notification.receiver.must_equal peter
    end
  end

  describe "relations with cover image" do
    it "creates the image and set it as the album's cover image" do
      image = create :image
      public_album.set_cover_image image
      public_album.cover_image.must_equal image
      image.covered_album.must_equal public_album
    end
  end

  describe "album's default hidden is false" do
    it "sets the hidden to false when create a new albume" do
      private_album.hidden.must_equal false
    end
  end

  describe ".total_likes" do
    it "returns total count for likes for the photos in the card" do
      photo_2 = create :photo, title: "second photo", description: "this is seond photo"
      album.photos << [photo, photo_2]
      peter.like_photo photo
      peter.like_photo photo_2
      allen.like_photo photo
      allen.like_photo photo_2
      
      album.total_likes.must_equal 4
    end
  end

  describe "destroys a card" do
    before do
      # @new_user =  create :user, email: "new@test.com", password: "11111111", first_name: "allen", last_name: "wang" , confirmed_at: Time.now
      photo.update album: album
      peter.send_invitation allen.id, album
      # peter.send_invitation @new_user.id, album
      allen.joins_album album

      album.destroy
    end

    it "destroys the card record in DB" do
      Album.all.wont_include album
    end

    it "removes the invitations related to it" do
      Invitation.count.must_equal 0
      allen.received_invitations.must_be :empty?
    end

    it "removes the notifications related to it" do
      Notification.count.must_equal 0
      allen.notifications.must_be :empty?
    end

    it "removes all the photos in the card" do
      Photo.all.wont_include photo
    end

    it "removes the relatinos with followers" do
      peter.joined_albums.wont_include album
      allen.joined_albums.wont_include album
    end
  end

  describe "validates name unique" do
    it "validates the name unique for public albums" do
      public_album
      ->{create :album, name: "public album", private: false, creator: peter}.must_raise ActiveRecord::RecordInvalid
    end

    it "does not validate the name unique for private albums" do
      public_album
      new_private = create :album, name: "public album", private: true, creator: peter
      Album.last.must_equal new_private
    end
  end

end
