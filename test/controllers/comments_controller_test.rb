require "test_helper"

describe CommentsController do
  helper_objects

  before do
    photo.update album: album
  end

  describe "GET index" do
    it "lists all the comments for the photo" do
      get :index, photo_id: photo.id, card_id: album.id
      assigns[:comments].must_match_array photo.comments
    end
  end

  describe "POST create" do
    describe "logged in user" do
      before do
        sign_in allen
      end

      it "creates an comment for the photo" do
        assert_difference("Comment.count") do
          post :create, photo_id: photo.id, comment: attributes_for(:comment, commenter: peter, content: "this is a comment"), card_id: album.id
        end
      end
    end
  end

end
