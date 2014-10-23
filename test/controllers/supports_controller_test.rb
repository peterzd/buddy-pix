require "test_helper"

describe SupportsController do

  let(:support) { create :support, sender_name: "peter zhao", subject: "test support", email: "peter@test.com", message: "this is a test support message" }

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supports)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates support" do
    assert_difference('Support.count') do
      post :create, support: (attributes_for :support, sender_name: "peter zhao", subject: "test support", email: "peter@test.com", message: "this is a test support message")
    end

    assert_redirected_to welcome_support_path
  end

  it "shows support" do
    get :show, id: support
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: support
    assert_response :success
  end

end
