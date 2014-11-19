class CreateImageWorker
  include Sidekiq::Worker

  def perform(image_path, photo_id)
    puts 'saving image'
    image = Image.create picture: File.new(image_path, "r")
    photo = Photo.find photo_id
    photo.image = image
    # image = Image.new picture: File.new(path, "r")
    # image.save
  end
end
