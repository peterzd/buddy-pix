class PhotoImageWorker
  include Sidekiq::Worker

  def perform(image_path, photo_id)
    image = Image.create picture: File.new(image_path, "r")
    photo = Photo.find photo_id
    photo.image = image
    File.delete(image_path)
  end
end
