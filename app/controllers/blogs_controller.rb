class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json, :xml

  def show
    respond_with(@blog)
  end

  def create_comment
    content = comment_params[:content]
    @blog = Blog.find params[:id]
    if comment_params[:image]
      image = Image.create comment_params[:image]
      comment = Comment.create commenter: current_user, commentable: @blog, content: content, image: image
      @blog.comments << comment
    else
      comment = Comment.create commenter: current_user, commentable: @blog, content: content
      @blog.comments << comment
    end
    redirect_to @blog
  end

  def reply
    binding.pry
    @blog = Blog.find params[:id]
    comment = Comment.find params[:comment_id]
    reply_content = comment_params[:content]

    if comment_params[:image]
      image = Image.create comment_params[:image]
      Comment.create commenter: current_user, commentable: comment, content: reply_content, image: image
    else
      Comment.create commenter: current_user, commentable: comment, content: reply_content
    end
    redirect_to @blog
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:commenter_id, :content, { image: [:picture] })
  end
end
