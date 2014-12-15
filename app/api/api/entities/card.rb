module API
  module Entities
    class Card < Grape::Entity
      expose :id, :name, :private, :caption, :created_at, :last_name, :hidden
      expose :creator, using: API::Entities::User, unless: { type: :with_cards }
      expose :cover_image, using: API::Entities::Image
      expose :photos, using: API::Entities::Photo, if: { type: :detail }
      expose :photos_count
      expose :likes
      expose :comments
      expose :followers_count
      expose :hit_count, if: { type: :detail }


      private
      def likes
        object.total_likes
      end

      def comments
        object.total_comments
      end

      def followers_count
        object.followers.count
      end

      def photos_count
        object.photos.count
      end
    end
  end
end
