module API
  module Entities
    class Photo < Grape::Entity
      expose :id, :title, :description, :created_at, :updated_at
      expose :image_url
      expose :images, using: API::Entities::Image
      expose :likes, using: API::Entities::Like
      expose :likes_count
      expose :comments, using: API::Entities::Comment
      expose :comments_count
      expose :creator, using: API::Entities::User
      expose :followers_count
      expose :privacy
      expose :album, as: :card
        
      private
      def image_url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{object.picture_url :medium}"
      end

      def followers_count
        object.album.followers.count
      end

      def privacy
        object.album.private? ? "private" : "public"
      end

      def likes_count
        object.likes.count
      end

      def comments_count
        object.comments.count
      end
    end
  end
end
