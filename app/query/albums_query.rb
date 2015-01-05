class AlbumsQuery
  NUMBER_FACTOR = 6

  class << self
    def user_following_cards(user, offset=0)
      user.joined_albums.where(hidden: [nil, false]).limit(NUMBER_FACTOR).offset(offset)
    end

    def unfollowed_cards_by(user)
      Album.includes(:user_relations).where("users_albums.user_id <> ?", user.id).references(:user_relations)
    end
  end
end
