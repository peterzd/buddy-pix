class AlbumImageWorker
  include Sidekiq::Worker

  def perform(image_path, album_id)
    image = Image.create picture: File.new(image_path, "r")
    album = Album.find album_id
    album.set_cover_image image
    File.delete(image_path)
  end
end
