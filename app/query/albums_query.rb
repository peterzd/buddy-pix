class AlbumsQuery
  NUMBER_FACTOR = 6
  NUMBER_FACTOR_APP = 10

  class << self
    def user_following_cards(user, offset=0)
      user.joined_albums.where(hidden: [nil, false]).limit(NUMBER_FACTOR).offset(offset)
    end

    def unfollowed_cards_by(user, offset=0)
      Album.where.not(id: user.joined_albums).where.not(private: true).limit(NUMBER_FACTOR_APP).offset(offset)
    end
  end
end
