require "test_helper"

describe UsersService do
  helper_objects

  let(:allen_album) {  create :album, caption: "album caption", name: "allen created this", private: true, creator: allen  }
  let(:allen_photo) {  create :photo, title: "test photo", description: "this is a new photo", album: allen_album, creator: allen  }

  before do
    [peter, allen, album]
    photo.update creator: peter, album: album
    peter.send_invitation allen.id, album
    peter.joins_album allen_album
    peter.like_photo allen_photo
    photo.tag_user allen.id
  end

  describe ".destroy_account" do
    before do
      UsersService.new(peter).destroy_account
    end

    it "destroys the user" do
      User.all.wont_include peter
    end

    it "removes all the cards the user created" do
      Album.all.wont_include album
    end

    it "removes all photos I created" do
      Photo.all.wont_include photo
    end

    it "removes all invitations I send out" do
      Invitation.count.must_equal 0
    end

    it "removes all my follow record" do
      allen_album.followers.wont_include peter
    end

    it "removes all my like records" do
      Like.count.must_equal 0
    end
    
    it "removes all notifications I send out" do
      Notification.count.must_equal 0
    end
  end

end

