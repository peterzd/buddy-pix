class ImagesController < ApplicationController
  before_action :set_image

  def like
    authorize :image, :like?
    current_user.like_image @image, mood: params[:mood]
  end

  private
  def set_image
    @image = Image.find params[:id]
  end
  # 10.28: not use this controller yet
  # def new
  #   @image = Image.new
  # end

  # def create
  #   @image = Image.new image_params
  #   @image.save!
  #   render nothing: true
  # end

  # private
  # def image_params
  #   params.require(:image).permit(:id, :picture)
  # end
end
