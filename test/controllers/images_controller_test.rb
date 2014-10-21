require "test_helper"

describe ImagesController do
  it "should get new" do
    get :new
    assert_response :success
  end

  it "should get create" do
    get :create
    assert_response :success
  end

end
