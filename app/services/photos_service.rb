class PhotosService
  def initialize(photo)
    @photo = photo
  end

  def process_tagged_users(photo_params)
    tagged_users = photo_params[:tagged_users]
    if tagged_users
      tagged_users.split("&").each do |tag|
        @photo.tag_user tag.split("=").last.to_i
      end
    end
  end
end
