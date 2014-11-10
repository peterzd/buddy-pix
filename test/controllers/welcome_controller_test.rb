require "test_helper"

describe WelcomeController do
  it "should get blog" do
    get :blog
    assert_response :success
  end

  describe "GET support" do
    it "shows the user a new support form" do
      get :support
      assigns[:support].wont_be_nil
      assert_response :success
    end
  end
end
