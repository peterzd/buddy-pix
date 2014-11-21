class CommentsController < ApplicationController
  def create
    @card = Album.find params[:card_id]
    @photo = Photo.find params[:photo_id]
    if comment_params[:image]
      image = Image.create comment_params[:image]
      current_user.comments_photo @photo, comment_params[:content], image
    else
      current_user.comments_photo @photo, comment_params[:content]
    end
    redirect_to card_photo_path(@card, @photo)
  end

  def index
    photo = Photo.find params[:photo_id]
    @comments = photo.comments
  end

  private
  def comment_params
    params.require(:comment).permit(:id, :commenter_id, :content, { image: [:picture] })
  end

end
