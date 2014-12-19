class UsersService

  def initialize(user)
    @user = user
  end

  def update_profile_cover(user_params, image_type)
    process_image(user_params, image_type)
    # process_image_background(user_params, image_type)
  end

  def update_cover_photo(user_params, image_type)
    process_image(user_params, image_type)
    # process_image_background(user_params, image_type)
  end

  def destroy_account
    @user.destroy
  end

  private
  def process_image(user_params, image_type)
    image = Image.create user_params[image_type]
    @user.send("set_#{image_type}", image)
  end

  def process_image_background(object_params, image_type)
    if object_params[image_type]
      name = object_params[image_type][:picture].original_filename
      directory = "tmp/uploaded_images"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(object_params[image_type][:picture].read) }

      UserProfileCoverWorker.perform_async path, @user.id, image_type.to_s
    end
  end

end
