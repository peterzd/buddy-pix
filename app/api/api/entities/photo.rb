module API
  module Entities
    class Photo < Grape::Entity
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id, :title, :description
      expose :image_url
      expose :image_height, unless: { type: :need_height }
      expose :images, using: API::Entities::Image
      expose :likes, using: API::Entities::Like
      expose :likes_count
      expose :comments, using: API::Entities::Comment
      expose :comments_count
      expose :creator, using: API::Entities::User
      expose :followers_count
      expose :privacy
      expose :album, as: :card
      expose :images_count
        
      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end

      private
      def images_count
        object.images.count
      end

      def image_url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{object.picture_url :medium}"
      end

      def image_height
        (750 / object.first_image.ratio).to_i
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
