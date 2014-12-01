class UserProfileCoverWorker
  include Sidekiq::Worker

  def perform(image_path, user_id, image_type)
    image = Image.create picture: File.new(image_path, "r")
    user = User.find user_id
    user.send("set_#{image_type}", image)
    File.delete(image_path)
  end

end
