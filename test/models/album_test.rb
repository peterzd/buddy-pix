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

end
