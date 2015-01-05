class PhotosQuery
  NUMBER_FACTOR = 6

  class << self
    def album_batch(album, offset=0)
      album.photos.order(updated_at: :desc).limit(NUMBER_FACTOR).offset(offset)
    end

    def user_wall_pics(user, offset=0)
      Photo.where(album: user.joined_albums).order(updated_at: :desc).limit(NUMBER_FACTOR).offset(offset)
    end

    def unfollowed_photos_by(user)
      cards = AlbumsQuery.unfollowed_cards_by(user)
      cards.inject([]) do |all_photos, c|
        all_photos.concat c.photos
      end
    end

  end
end
