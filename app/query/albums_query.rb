class AlbumsQuery
  NUMBER_FACTOR = 12

  class << self
    def user_following_cards(user, offset=0)
      user.joined_albums.limit(NUMBER_FACTOR).offset(offset)
    end
  end
end
