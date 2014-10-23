require "test_helper"

describe WelcomeController do
  it "should get blog" do
    get :blog
    assert_response :success
  end
end
