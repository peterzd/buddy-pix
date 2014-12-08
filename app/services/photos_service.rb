class PhotosService
  def initialize(photo)
    @photo = photo
  end

  def save_photo(photo_params)
    if @photo.save
      process_tagged_users(photo_params)
      process_image(photo_params)
      send_notifications
      true
    else
      false
    end
  end

  private
  def process_tagged_users(photo_params)
    tagged_users = photo_params[:tagged_users]
    if tagged_users
      tagged_users.split("&").each do |tag|
        @photo.tag_user tag.split("=").last.to_i
      end
    end
  end

  # Later we can use background job to make it faster
  def process_image(object_params)
    if object_params[:image]
      name = object_params[:image][:picture].original_filename
      directory = "tmp/uploaded_images"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(object_params[:image][:picture].read) }
      PhotoImageWorker.perform_async path, @photo.id
    end
  end

  def send_notifications
    receivers = @photo.album.followers
    maker = @photo.creator
    receivers.each do |receiver|
      send_notification(maker: maker, action: Notification::ACTION[:post_photo], object: @photo, receiver: receiver) unless maker == receiver
    end
  end

  def send_notification(options={})
    Notification.create options
  end
end
