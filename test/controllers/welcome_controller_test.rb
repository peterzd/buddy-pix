require "test_helper"

describe WelcomeController do
  it "should get index" do
    get :index
    assert_response :success
  end

  it "should get about_us" do
    get :about_us
    assert_response :success
  end

  it "should get terms" do
    get :terms
    assert_response :success
  end

  it "should get blog" do
    get :blog
    assert_response :success
  end

  it "should get support" do
    get :support
    assert_response :success
  end

end
