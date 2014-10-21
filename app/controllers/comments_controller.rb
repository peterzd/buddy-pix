class CommentsController < ApplicationController
  def create
    @comment = Comment.create comment_params
    render nothing: true
  end

  def index
    image = Image.find params[:image_id]
    @comments = image.comments
  end

  private
  def comment_params
    params.require(:comment).permit(:id, :commenter_id, :content)
  end

end
