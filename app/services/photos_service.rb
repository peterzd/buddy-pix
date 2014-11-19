class PhotosService
  def initialize(photo, photo_params={})
    @photo = photo
    @params = photo_params
  end

  def save_photo
    if @photo.save
      process_tagged_users
      process_image
      # later this method could be placed in background work
      send_notifications
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
#         name = photo_params[:image][:picture].original_filename
#         directory = "tmp/uploaded_images"
#         path = File.join(directory, name)
#         File.open(path, "wb") { |f| f.write(photo_params[:image][:picture].read) }
#         @photo.set_image path
    end
  end

  def send_notifications
    receivers = @photo.album.followers
    maker = @photo.creator
    receivers.each do |receiver|
      send_notification(maker: maker, action: Notification::ACTION[:post_photo], object: @photo, receiver: receiver)
    end
  end

  def send_notification(options={})
    Notification.create options
  end
end
