require "test_helper"

describe AlbumsController do

  let(:album) { create :album, caption: "album caption", name: "first album", private: true }

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:albums)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates album" do
    assert_difference('Album.count') do
      post :create, album: attributes_for(:album, caption: "album caption", name: "first album", private: true)
    end

    assert_redirected_to album_path(assigns(:album))
  end

  it "shows album" do
    get :show, id: album
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: album
    assert_response :success
  end

  it "updates album" do
    patch :update, id: album, album: attributes_for(:album, caption: "chaged caption", private: false)
    album.reload
    album.wont_be :private?
    album.caption.must_equal "chaged caption"

  end

  it "destroys album" do
    album
    assert_difference('Album.count', -1) do
      delete :destroy, id: album
    end

    assert_redirected_to albums_path
  end

end
