module API
  module Entities
    class User < Grape::Entity
      expose :id, :email, :user_name, :first_name, :last_name, :phone_number
      expose :profile_cover, :cover_photo, using: API::Entities::Image
      expose :created_albums, using: API::Entities::Card, if: { type: :with_cards }
      expose :authentication_token, if: { type: :access_token }, as: :access_token

      expose :created_cards_count, if: { type: :detail }
      expose :uploaded_pics_count, if: { type: :detail }
      expose :total_likes_count, if: { type: :detail }
      expose :total_comments_count, if: { type: :detail }

      private
      def created_cards_count
        object.created_albums.count
      end

      def uploaded_pics_count
        object.uploaded_photos.count
      end

      def total_likes_count
        object.total_likes
      end

      def total_comments_count
        object.total_comments
      end
    end
  end
end
