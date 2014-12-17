class PhotosService
  def initialize(photo)
    @photo = photo
  end

  def save_photo(photo_params)
    if @photo.save
      process_tagged_users(photo_params)
      process_images(photo_params)
      # process_image(photo_params)
      send_notifications
      true
    else
      false
    end
  end

  def save_photo_api(image, tagged_ids)
    if @photo.save
      if tagged_ids
        tagged_ids.each do |tagged_hash|
          @photo.tag_user tagged_hash[:id].to_i
        end
      end
      @photo.images << image
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
  # only for one image
  # def process_image(object_params)
  #   if object_params[:image]
  #     name = object_params[:image][:picture].original_filename
  #     directory = "tmp/uploaded_images"
  #     path = File.join(directory, name)
  #     File.open(path, "wb") { |f| f.write(object_params[:image][:picture].read) }
  #     PhotoImageWorker.perform_async path, @photo.id
  #   end
  # end

  # uploaded multiple images
  def process_images(object_params)
    ids = object_params[:image_ids][1..-1].split(",").map &:to_i
    ids.each do |id|
      @photo.images << Image.find(id)
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
