module API
  module Entities
    class User < Grape::Entity
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id, :email, :user_name, :first_name, :last_name, :phone_number
      expose :profile_cover, :cover_photo, using: API::Entities::Image
      expose :profile_cover_url
      expose :cover_photo_url
      expose :created_albums, using: API::Entities::Card, if: { type: :with_cards }
      expose :authentication_token, if: { type: :access_token }, as: :access_token

      expose :created_cards_count, if: { type: :detail }
      expose :uploaded_pics_count, if: { type: :detail }
      expose :total_likes_count, if: { type: :detail }
      expose :total_comments_count, if: { type: :detail }
      expose :followers_count, if: { type: :detail }

      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end

      private
      def profile_cover_url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        if object.profile_cover.nil?
          object.profile_cover_url
        else
          "#{host}#{object.profile_cover_url :medium}"
        end
      end

      def cover_photo_url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        if object.cover_photo.nil?
          ""
        else
          "#{host}#{object.cover_photo_url :medium}"
        end
      end

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

      def followers_count
        object.created_albums.inject(sum=0) do |sum, card|
          sum += card.followers.count
        end
      end
    end
  end
end
