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
      allen.joins_album(album)
    end

    it "adds the card to the user's joined_albums list" do
      allen.joined_albums.must_include album
    end

    it "adds the user to the card's followers list" do
      album.followers.must_include allen
    end

    it "updates the card's updated_at" do
      relation = UsersAlbums.last
      album.updated_at.to_s.must_equal relation.created_at.to_s
    end
  end

  describe ".unfollow_album" do
    before do
      allen.joins_album album
    end

    it "remove the album from the user's joined_albums" do
      allen.unfollow_album album
      allen.joined_albums.wont_include album
    end

    it "remove the user from the album's followers" do
      allen.unfollow_album album
      album.followers.wont_include allen
    end
  end

  describe ".hidden_cards" do
    it "lists all the user's hidden cards" do
      [album, private_album, public_album].each do |card|
        card.update hidden: true
      end
      peter.hidden_cards.must_match_array [album, private_album, public_album]
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
      photo.update album: album, creator: allen
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

    it "adds one to the user's comments" do
      comment = Comment.last
      peter.comments.must_include comment
      peter.commented_images.must_include photo
    end

    it "has content" do
      peter.comments_photo photo, "good one"
      Comment.last.content.must_equal "good one"
    end

    it "updates the photo's card's updated_at" do
      comment = Comment.last
      album.updated_at.to_s.must_equal comment.created_at.to_s
    end
    
    it "sets the last_updater for the photo as the user" do
      photo.updater.must_equal peter
    end

    it "creates notification to the photo's creator" do
      notification = allen.notifications.last
      notification.maker.must_equal peter
      notification.action.must_equal Notification::ACTION[:comment]
      notification.object.must_equal photo
      notification.receiver.must_equal allen
    end
  end

  describe ".reply_comment" do
    before do
      photo.update album: album
      peter.comments_photo photo
      @comment = Comment.last
      allen.reply_comment @comment
    end

    it "adds a reply to the comment" do
      reply = Comment.last
      @comment.replies.must_include reply
    end
  end

  describe "relations with likes" do
    describe "user likes an image" do
      before do
        photo.update album: album, creator: allen
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

      it "sets the last_updater for the photo as the user" do
        photo.updater.must_equal peter
      end

      it "creates notification to the photo's creator" do
        notification = allen.notifications.last
        notification.maker.must_equal peter
        notification.action.must_equal Notification::ACTION[:like]
        notification.object.must_equal photo
        notification.receiver.must_equal allen
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
      allen.total_photos.must_match_array []
      allen.total_photos.count.must_equal 0
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

  describe ".profile_cards" do
    before do
      album.update_columns updated_at: 3.days.ago
      private_album.update_columns updated_at: 2.days.ago
      public_album.update_columns updated_at: 1.days.ago
    end

    describe "returns the cards that I followed order by social feed date" do
      it "other user follows a card" do
        allen.joins_album private_album
        peter.profile_cards.must_equal [private_album, public_album, album]
      end

      it "someone likes one photo of a card" do
        photo.update album: album
        allen.like_photo photo
        peter.profile_cards.must_equal [album, public_album, private_album]
      end

      it "someone comments on a photo" do
        photo.update album: album
        allen.comments_photo photo

        peter.profile_cards.must_equal [album, public_album, private_album]
      end
    end
  end

  describe ".my_wall_pics" do
    before do
      album.update creator: allen
      allen.joins_album public_album
      @photo_1 = create :photo, album: album
      @photo_2 = create :photo, album: public_album
      @photo_3 = create :photo, album: private_album
      @photo_4 = create :photo, album: public_album
    end

    it "returns the photos belongs to albums which I followed" do
      allen.my_wall_pics.must_match_array [@photo_1, @photo_2, @photo_4]
      allen.my_wall_pics.wont_include @photo_3
    end

    describe "returns the photo order by updated date" do
      it "upload a new photo to a followed album" do
        allen.my_wall_pics.must_equal [@photo_4, @photo_2, @photo_1]
      end

      it "someone likes a photo" do
        peter.like_photo @photo_1
        allen.my_wall_pics.must_equal [@photo_1, @photo_4, @photo_2]
      end

      it "someone comments on a photo" do
        peter.comments_photo @photo_2
        allen.my_wall_pics.must_equal [@photo_2, @photo_4, @photo_1]
      end
    end
  end

  describe "relations with photos" do
    describe "has many uploaded photos" do
      it "creates a photo with creator" do
        photo.update creator: peter
        peter.uploaded_photos.must_include photo
      end
    end
  end

end
