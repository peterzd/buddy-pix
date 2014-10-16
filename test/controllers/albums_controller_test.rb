require "test_helper"

describe AlbumsController do

  let(:album) { albums :one }

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
      post :create, album: { caption: @album.caption, name: @album.name, private: @album.private }
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
    put :update, id: album, album: { caption: @album.caption, name: @album.name, private: @album.private }
    assert_redirected_to album_path(assigns(:album))
  end

  it "destroys album" do
    assert_difference('Album.count', -1) do
      delete :destroy, id: album
    end

    assert_redirected_to albums_path
  end

end
