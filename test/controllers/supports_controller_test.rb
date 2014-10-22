require "test_helper"

describe SupportsController do

  let(:support) { supports :one }

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
      post :create, support: { email: @support.email, message: @support.message, sender_name: @support.sender_name, subject: @support.subject }
    end

    assert_redirected_to support_path(assigns(:support))
  end

  it "shows support" do
    get :show, id: support
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: support
    assert_response :success
  end

  it "updates support" do
    put :update, id: support, support: { email: @support.email, message: @support.message, sender_name: @support.sender_name, subject: @support.subject }
    assert_redirected_to support_path(assigns(:support))
  end

  it "destroys support" do
    assert_difference('Support.count', -1) do
      delete :destroy, id: support
    end

    assert_redirected_to supports_path
  end

end
