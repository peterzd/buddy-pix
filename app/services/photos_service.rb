class PhotosService
  def initialize(photo, photo_params={})
    @photo = photo
    @params = photo_params
  end

  def save_photo
    if @photo.save
      process_tagged_users
      process_image
      true
    else
      false
    end
  end

  private
  def process_tagged_users
    tagged_users = @params[:tagged_users]
    if tagged_users
      tagged_users.split("&").each do |tag|
        @photo.tag_user tag.split("=").last.to_i
      end
    end
  end

  # Later we can use background job to make it faster
  def process_image
    if @params[:image]
      image = Image.create @params[:image]
      @photo.image = image
    end
  end
end
