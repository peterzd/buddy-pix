require "test_helper"

describe Image do
  helper_objects

  it "must be valid" do
    image.must_be :valid?
  end

  describe "relations with likes" do
    describe "user likes an image" do
      before do
        peter.like_image image, mood: Like::MOOD[:cool]
      end

      it "adds a record to the image's likers list" do
        image.likers.must_include peter
      end

      it "sets the mood to the like" do
        image.likes.last.mood.must_equal Like::MOOD[:cool]
      end
    end
  end
end
