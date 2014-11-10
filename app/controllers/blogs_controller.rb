class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json, :xml

  def index
    authorize :blog, :index?
    @blogs = Blog.all
    respond_with(@blogs)
  end

  def show
    respond_with(@blog)
  end

  def new
    @blog = Blog.new
    authorize @blog
    respond_with(@blog)
  end

  def edit
    authorize @blog
  end

  def create
    @blog = Blog.new(blog_params)
    authorize @blog
    @blog.save
    respond_with(@blog)
  end

  def update
    authorize @blog
    @blog.update(blog_params)
    respond_with(@blog)
  end

  def destroy
    authorize @blog
    @blog.destroy
    respond_with(@blog)
  end

  private
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(:content)
    end
end
