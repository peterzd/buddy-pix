require "test_helper"

describe AlbumsController do

  let(:album) { create :album, caption: "album caption", name: "first album", private: true }
  let(:admin) { create :admin_user, email: "admin@example.com", password: "password", first_name: "admin", last_name: "god" }
  let(:peter) { create :user, email: "peter@test.com", password: "11111111", first_name: "peter", last_name: "zhao" }
  let(:allen) { create :user, email: "allen@test.com", password: "11111111", first_name: "allen", last_name: "wang" }

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

        # assert_redirected_to album_path(assigns(:album))
      end
    end
  end

  # it "shows album" do
  #   get :show, id: album
  #   assert_response :success
  # end

  describe "POST hide_card" do
    before do
      album.update creator: peter
    end

    describe "logged in as normal user" do
      before do
        sign_in allen
      end

      it "can not hide this card" do
        post :hide_card, id: album.id
        album.reload.hidden.must_equal false
      end
    end

    describe "logged in as the owner of the card" do
      before do
        sign_in peter
      end

      it "can hide the card" do
        post :hide_card, id: album.id
        album.reload.hidden.must_equal true
      end
    end

    describe "logged in as Admin" do
      before do
        sign_in admin
      end

      it "can hide the card" do
        post :hide_card, id: album.id
        album.reload.hidden.must_equal true
      end
    end
  end
end
