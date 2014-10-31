require "test_helper"

describe PhotosController do
  helper_objects

  describe "GET like" do
    describe "not logged in user" do
      it "can not like the photo" do
        xhr :get, :like, mood: Like::MOOD[:cool], id: photo.id
        photo.likes.count.must_equal 0
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
        xhr :get, :like, mood: Like::MOOD[:cool], id: photo.id
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

end
