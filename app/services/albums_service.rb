class AlbumsService

  def initialize(album) 
    @album = album
  end

  def save_album(album_params)
    if @album.save
      process_image(album_params)
      true
    else
      false
    end
  end

  protected
  def process_image(object_params)
    if object_params[:cover_image]
      name = object_params[:cover_image][:picture].original_filename
      directory = "tmp/uploaded_images"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(object_params[:cover_image][:picture].read) }

      AlbumImageWorker.perform_async path, @album.id
    end
  end
end

