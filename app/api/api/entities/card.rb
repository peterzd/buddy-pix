module API
  module Entities
    class Card < Grape::Entity
      expose :name, :private, :caption, :created_at, :last_name, :hidden
      expose :creator, using: API::Entities::User, unless: { type: :with_cards }
      expose :cover_image, using: API::Entities::Image
      expose :photos, using: API::Entities::Photo
      expose :likes
      expose :comments
      expose :followers_count

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
    end
  end
end
