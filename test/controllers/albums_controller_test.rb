require "test_helper"

describe AlbumsController do

  let(:album) { create :album, caption: "album caption", name: "first album", private: true }
  let(:peter) { create :user, email: "peter@test.com", password: "11111111", first_name: "peter", last_name: "zhao" }

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

  # it "gets edit" do
  #   get :edit, id: album
  #   assert_response :success
  # end

  # it "updates album" do
  #   patch :update, id: album, album: attributes_for(:album, caption: "chaged caption", private: false)
  #   album.reload
  #   album.wont_be :private?
  #   album.caption.must_equal "chaged caption"

  # end

  # it "destroys album" do
  #   album
  #   assert_difference('Album.count', -1) do
  #     delete :destroy, id: album
  #   end

  #   assert_redirected_to albums_path
  # end

end
