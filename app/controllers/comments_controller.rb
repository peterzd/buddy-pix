class CommentsController < ApplicationController
  def create
    @comment = Comment.create comment_params
    render nothing: true
  end

  def index
    photo = Photo.find params[:photo_id]
    @comments = photo.comments
  end

  private
  def comment_params
    params.require(:comment).permit(:id, :commenter_id, :content)
  end

end
