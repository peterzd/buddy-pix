module API
  module Entities
    class Card < Grape::Entity
      include Rails.application.routes.url_helpers
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id, :name, :private, :caption, :last_name, :hidden
      expose :creator, using: API::Entities::User, unless: { type: :with_cards }
      expose :cover_image, using: API::Entities::Image
      expose :photos, using: API::Entities::Photo, if: { type: :detail }
      expose :photos_count
      expose :likes
      expose :comments
      expose :followers_count
      expose :hit_count, if: { type: :detail }
      expose :card_link

      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end

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

      def card_link
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{card_path(object)}"
      end
    end
  end
end
