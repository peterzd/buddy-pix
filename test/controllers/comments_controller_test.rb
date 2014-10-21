require "test_helper"

describe CommentsController do
  let(:image) { create :image }
  let(:peter) { create :user, first_name: "peter", last_name: "zhao", email: "peter@test.com", password: "11111111" }

  describe "GET index" do
    it "lists all the comments for the photo" do
      get :index, image_id: image.id
      assigns[:comments].must_match_array image.comments
    end
  end

  describe "POST create" do
    it "creates an comment for the photo" do
      assert_difference("Comment.count") do
        post :create, image_id: image.id, comment: attributes_for(:comment, commenter: peter, content: "this is a comment")
      end
      assert_response :success
    end
  end

end
