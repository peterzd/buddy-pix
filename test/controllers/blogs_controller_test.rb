require "test_helper"

describe BlogsController do

  let(:blog) { create :blog, title: "test blog", content: "this is content of the blog" }

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blogs)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates blog" do
    assert_difference('Blog.count') do
      post :create, blog: attributes_for(:blog, title: "test blog", content: "this is content of the blog")
    end

    assert_redirected_to blog_path(assigns(:blog))
  end

  it "shows blog" do
    get :show, id: blog
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: blog
    assert_response :success
  end

  it "updates blog" do
    patch :update, id: blog, blog: attributes_for(:blog, content: "update content")
    blog.reload.content.must_equal "update content"
    assert_redirected_to blog_path(assigns(:blog))
  end

  it "destroys blog" do
    blog.save
    assert_difference('Blog.count', -1) do
      delete :destroy, id: blog
    end

    assert_redirected_to blogs_path
  end

end
