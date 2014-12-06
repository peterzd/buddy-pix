class PhotosQuery
  NUMBER_FACTOR = 12

  class << self
    def album_batch(album, offset=0)
      album.photos.order(updated_at: :desc).limit(NUMBER_FACTOR).offset(offset)
    end

    def user_wall_pics(user, offset=0)
      Photo.where(album: user.joined_albums).order(updated_at: :desc).limit(NUMBER_FACTOR).offset(offset)
    end

  end
end
