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
      album.update_columns updated_at: 1.day.ago
      peter.joins_album(album)
    end

    it "adds the card to the user's joined_albums list" do
      peter.joined_albums.must_include album
    end

    it "adds the user to the card's followers list" do
      album.followers.must_include peter
    end

    it "updates the card's updated_at" do
      relation = UsersAlbums.last
      album.updated_at.to_s.must_equal relation.created_at.to_s
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
    before do
      photo.update album: album
      album.update_columns updated_at: 1.day.ago
      peter.comments_photo photo
    end

    it "creates a new comment" do
      Comment.count.must_equal 1
    end

    it "adds a comment to the photo's comments" do
      comment = Comment.last
      photo.comments.must_include comment
    end

    it "updates the photo's card's updated_at" do
      comment = Comment.last
      album.updated_at.to_s.must_equal comment.created_at.to_s
    end
  end

  describe "relations with likes" do
    describe "user likes an image" do
      before do
        photo.update album: album
        album.update_columns updated_at: 1.day.ago
        peter.like_photo photo, mood: Like::MOOD[:cool]
      end

      it "adds a record to the user's liked_images list" do
        peter.liked_photos.must_include photo
      end

      it "sets the mood to the like" do
        Like.count.must_equal 1
        peter.likes.last.mood.must_equal Like::MOOD[:cool]
      end

      it "updates the photo's card's updated_at" do
        like = Like.last
        album.updated_at.to_s.must_equal like.created_at.to_s
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

  describe "relations with invitations" do
    describe ".send_invitation" do
      it "creates a new invitation" do
        peter.send_invitation allen.id, album
        invitation = Invitation.first
        invitation.sender.must_equal peter
        invitation.card.must_equal album
        invitation.receiver.must_equal allen
      end
    end

    describe ".my_pending_invitations" do
      it "returns all invitations that I am the receiver and status is pending" do
        pending_invitation = create :invitation, sender: allen, receiver: peter, card: album, status: Invitation::STATUS[:pending]
        accepted_invitation = create :invitation, sender: allen, receiver: peter, card: album, status: Invitation::STATUS[:accepted]
        rejected_invitation = create :invitation, sender: allen, receiver: peter, card: album, status: Invitation::STATUS[:rejected]
        peter.my_pending_invitations.must_match_array [pending_invitation]
      end
    end
  end
end
