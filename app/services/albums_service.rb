class AlbumsService

  def initialize(album) 
    @album = album
  end

  def save_album(album_params)
    if @album.save
      process_image(album_params) if album_params[:cover_image]
      true
    else
      false
    end
  end

  def update_cover(album_params)
    process_image(album_params)
  end

  class << self
    def search_cards_batch(search_params, page)
      cards = Album.search(search_params).page(page).per(8).records
    end
  end

  protected
  def process_image(album_params)
    image = Image.create album_params[:cover_image]
    @album.set_cover_image image
  end

  # async process
  # def process_image(object_params)
  #   if object_params[:cover_image]
  #     name = object_params[:cover_image][:picture].original_filename
  #     directory = "tmp/uploaded_images"
  #     path = File.join(directory, name)
  #     File.open(path, "wb") { |f| f.write(object_params[:cover_image][:picture].read) }

  #     AlbumImageWorker.perform_async path, @album.id
  #   end
  # end
end

