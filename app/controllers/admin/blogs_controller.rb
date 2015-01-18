class Admin::BlogsController < Admin::ApplicationController
  respond_to :html
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index
    @blogs = Blog.all.order(created_at: :desc)
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    authorize @blog
    if @blog.save
      redirect_to admin_blogs_path
    end
  end

  def destroy
    authorize @blog
    @blog.destroy
    respond_with(:admin, @blog)
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :content)
  end

end
