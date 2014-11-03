require "test_helper"

describe PhotosController do
  helper_objects

  describe "GET like" do
    before do
      photo.album = album
    end

    describe "not logged in user" do
      it "can not like the photo" do
        xhr :get, :like, mood: Like::MOOD[:cool], id: photo.id, card_id: album.id
        photo.likes.count.must_equal 0
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
        xhr :get, :like, mood: Like::MOOD[:cool], id: photo.id, card_id: album.id
      end

      it "adds a like to the user" do
        peter.liked_photos.must_include photo
      end

      it "adds a user to the photo's likers" do
        photo.likers.must_include peter
      end

      it "sets the mood for the like record" do
        photo.likes.first.mood.must_equal "cool"
      end
    end
  end

  describe "GET new" do
    before do
      album.update creator: peter
    end

    describe "not logged in user" do
      it "can not access the page" do
        get :new, card_id: album.id
        assert_redirected_to root_path
      end
    end

    describe "logged in as other user" do
      before do
        sign_in allen
      end

      it "can not access the page" do
        get :new, card_id: album.id
        assert_redirected_to root_path
      end
    end

    describe "logged in as the card's owner" do
      before do
        sign_in peter
      end

      it "can access the page" do
        get :new, card_id: album.id
        assert_response :success
      end
    end

    describe "logged in as Admin" do
      before do
        sign_in admin
      end

      it "can access the page" do
        get :new, card_id: album.id
        assert_response :success
      end
    end
  end

  describe "POST create" do
    before do
      album.update creator: peter
    end

    describe "the card is public" do
      before do
        album.update private: false
      end

      describe "logged in as other user" do
        before do
          sign_in allen
        end

        it "can create a new photo for the card" do
          assert_difference("Photo.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
          assert_redirected_to cards_path
        end

        it "adds one photo for the card" do
          assert_difference("album.photos.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
        end
      end

      describe "logged in as the card's owner" do
        before do
          sign_in peter
        end

        it "can create a new photo for the card" do
          assert_difference("Photo.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
          assert_redirected_to cards_path
        end

        it "adds one photo for the card" do
          assert_difference("album.photos.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
        end
      end

      describe "logged in as Admin" do
        before do
          sign_in admin
        end

        it "can create a new photo for the card" do
          assert_difference("Photo.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
          assert_redirected_to cards_path
        end

        it "adds one photo for the card" do
          assert_difference("album.photos.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
        end
      end
    end


    describe "the card is private" do
      before do
        album.update private: true
      end

      describe "logged in as other user" do
        before do
          sign_in allen
        end

        it "can not create a new photo for the card" do
          assert_no_difference("Photo.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
          assert_redirected_to root_path
        end
      end

      describe "logged in as joined the album" do
        before do
          allen.joins_album album
          sign_in allen
        end

        it "can create a new photo for the card" do
          assert_difference("Photo.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
          assert_redirected_to cards_path
        end

        it "adds one photo for the card" do
          assert_difference("album.photos.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
        end

      end

      describe "logged in as the card's owner" do
        before do
          sign_in peter
        end

        it "can create a new photo for the card" do
          assert_difference("Photo.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
          assert_redirected_to cards_path
        end

        it "adds one photo for the card" do
          assert_difference("album.photos.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
        end
      end

      describe "logged in as Admin" do
        before do
          sign_in admin
        end

        it "can create a new photo for the card" do
          assert_difference("Photo.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
          assert_redirected_to cards_path
        end

        it "adds one photo for the card" do
          assert_difference("album.photos.count") do
            post :create, card_id: album.id, photo: attributes_for(:photo, title: "photo title", description: "this is photo description", image: image)
          end
        end
      end

    end

  end

end
