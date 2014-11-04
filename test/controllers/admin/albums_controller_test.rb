require "test_helper"

describe Admin::AlbumsController do
  helper_objects

  describe "DELETE destroy" do
    it "destroys the card" do
      album
      delete :destroy, id: album
      Album.count.must_equal 0
    end
  end
end
