module API
  module Entities
    class User < Grape::Entity
      expose :email, :username, :first_name, :last_name, :phone_number
      expose :profile_cover, :cover_photo, using: API::Entities::Image
      expose :created_albums, using: API::Entities::Card, if: { type: :with_cards }
      expose :authentication_token, if: { type: :access_token }, as: :access_token
    end
  end
end
