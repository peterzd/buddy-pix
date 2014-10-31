require "test_helper"

describe ImagesController do
  helper_objects

  describe "GET like" do
    describe "not logged in user" do
      it "can not like the image" do
        xhr :get, :like, mood: Like::MOOD[:cool], id: image.id
        image.likes.count.must_equal 0
      end
    end

    describe "logged in user" do
      before do
        sign_in peter
        xhr :get, :like, mood: Like::MOOD[:cool], id: image.id
      end

      it "adds a like to the user" do
        peter.liked_images.must_include image
      end

      it "adds a user to the image's likers" do
        image.likers.must_include peter
      end

      it "sets the mood for the like record" do
        image.likes.first.mood.must_equal "cool"
      end
    end
  end
end
