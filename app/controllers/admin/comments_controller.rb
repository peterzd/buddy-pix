class Admin::CommentsController < ApplicationController
  respond_to :html
  before_action :set_comment

  def index

  end

  def destroy
    @photo = Photo.find params[:photo_id]
    @comment.destroy
    redirect_to admin_photo_path(@photo)
  end

  private
  def set_comment
    @comment = Comment.find params[:id]
  end
end
