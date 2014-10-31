require "test_helper"

describe AlbumsController do
  helper_objects

  describe "GET index" do
    describe "not logged in user" do
      it "can not access the page" do
        get :index
        assert_redirected_to root_path
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "can access the page" do
        get :index
        assert_response :success
      end

      it "lists all non-hidden albums" do
        album.update creator: peter
        hidden_card =  create :album, caption: "this is hidden album", name: "hidden album", private: false, hidden: true, creator: peter
        get :index
        assigns[:albums].wont_include hidden_card
      end
    end
  end

  describe "GET new" do
    describe "not logged in" do
      it "redirects to root path" do
        get :new
        assert_redirected_to root_path
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "can access the page" do
        get :new
        assert_response :success
      end
    end
  end

  describe "POST create album" do
    describe "not logged in" do
      it "can not access the page" do
        post :create, album: attributes_for(:album, caption: "album caption", name: "first album", private: true)
        assert_redirected_to root_path
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
      end

      it "creates a new card" do
        assert_difference('Album.count') do
          post :create, album: attributes_for(:album, caption: "album caption", name: "first album", private: true)
        end
        assert_redirected_to cards_path
      end

      it "sets the creator as the current_user" do
        post :create, album: attributes_for(:album, caption: "album caption", name: "first album", private: true)
        Album.last.creator.must_equal peter
      end
    end
  end

  describe "POST hide_card" do
    before do
      album.update creator: peter
    end

    describe "logged in as normal user" do
      before do
        sign_in allen
      end

      it "can not hide this card" do
        xhr :post, :hide_card, id: album.id
        album.reload.wont_be :hidden
      end
    end

    describe "logged in as the owner of the card" do
      before do
        sign_in peter
      end

      it "can hide the card" do
        xhr :post, :hide_card, id: album.id
        album.reload.must_be :hidden
      end
    end

    describe "logged in as Admin" do
      before do
        sign_in admin
      end

      it "can hide the card" do
        xhr :post, :hide_card, id: album.id
        album.reload.must_be :hidden
      end
    end
  end
end
