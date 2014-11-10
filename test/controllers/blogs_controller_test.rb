require "test_helper"

describe BlogsController do
  helper_objects

  describe "GET index" do
    describe "not logged in user" do
      it "can not access the page" do
        get :index
        assert_redirected_to root_path
      end
    end

    describe "logged in as normal user" do
      before do
        sign_in peter
      end

      it "can not access the page" do
        get :index
        assert_redirected_to root_path
      end
    end

    describe "logged in as Admin" do
      before do
        sign_in admin
      end

      it "can access the page" do
        get :index
        assert_response :success
        assert_not_nil assigns(:blogs)
      end
    end
  end

  describe "GET new" do
    describe "not logged in user" do
      it "can not access the page" do
        get :new
        assert_redirected_to root_path
      end
    end

    describe "logged in as normal user" do
      before do
        sign_in peter
      end

      it "can not access the page" do
        get :new
        assert_redirected_to root_path
      end
    end

    describe "logged in as Admin" do
      before do
        sign_in admin
      end

      it "can access the page" do
        get :new
        assert_response :success
      end
    end
  end

  describe "creates blog" do
    describe "not logged in user" do
      it "can not creat a new blog" do
        post :create, blog: attributes_for(:blog, title: "test blog", content: "this is content of the blog")
        Blog.count.must_equal 0
      end
    end

    describe "logged in as normal user" do
      before do
        sign_in peter
      end

      it "can not creat a new blog" do
        post :create, blog: attributes_for(:blog, title: "test blog", content: "this is content of the blog")
        Blog.count.must_equal 0
      end
    end

    describe "logged in as admin" do
      before do
        sign_in admin
      end

      it "can create a new blog" do
        assert_difference('Blog.count') do
          post :create, blog: attributes_for(:blog, title: "test blog", content: "this is content of the blog")
        end

        assert_redirected_to blog_path(assigns(:blog))
      end
    end
  end

  it "shows blog" do
    get :show, id: blog
    assert_response :success
  end

  describe "GET edit" do
    describe "not logged in user" do
      it "can not access the page" do
        get :edit, id: blog
        assert_redirected_to root_path
      end
    end

    describe "logged in as normal user" do
      before do
        sign_in peter
      end

      it "can not access the page" do
        get :edit, id: blog
        assert_redirected_to root_path
      end
    end

    describe "logged in as admin" do
      before do
        sign_in admin
      end

      it "can access the page" do
        get :edit, id: blog
        assert_response :success
      end
    end
  end

  describe "PATCH update blog" do
    describe "not logged in user" do
      it "can not update the blog" do
        patch :update, id: blog, blog: attributes_for(:blog, content: "update content")
        blog.reload.content.wont_equal "update content"
        assert_redirected_to root_path
      end
    end

    describe "logged in as normal user" do
      before do
        sign_in peter
      end

      it "can not update the blog" do
        patch :update, id: blog, blog: attributes_for(:blog, content: "update content")
        blog.reload.content.wont_equal "update content"
        assert_redirected_to root_path
      end
    end

    describe "logged in as admin" do
      before do
        sign_in admin
      end

      it "can update the blog" do
        patch :update, id: blog, blog: attributes_for(:blog, content: "update content")
        blog.reload.content.must_equal "update content"
        assert_redirected_to blog_path(assigns(:blog))
      end
    end
  end

  describe "DELETE destroys blog" do
    before do
      blog
    end

    describe "not logged in user" do
      it "can not delete the blog" do
        delete :destroy, id: blog
        Blog.count.must_equal 1
        assert_redirected_to root_path
      end
    end

    describe "logged in as normal user" do
      before do
        sign_in peter
      end

      it "can not delete the blog" do
        delete :destroy, id: blog
        Blog.count.must_equal 1
        assert_redirected_to root_path
      end
    end

    describe "logged in as admin" do
      before do
        sign_in admin
      end

      it "can delete the blog" do
        assert_difference('Blog.count', -1) do
          delete :destroy, id: blog
        end

        assert_redirected_to blogs_path
      end
    end
  end
end
