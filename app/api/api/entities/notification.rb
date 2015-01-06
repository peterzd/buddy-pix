module API
  module Entities
    class Notification < Grape::Entity
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id
      expose :maker, using: API::Entities::User
      expose :action
      # expose :item
      # expose :item_type
      expose :is_read
      expose :message
      expose :created_at, :updated_at

      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end

      private
      def message
        case object.action
        when "comment_photo"
          return "#{object.maker.user_name} comments on #{object.object.title}."
        when "joins_card"
          return "#{object.maker.user_name} has joined #{object.object.name}."
        when "accept_invitation"
          return "#{object.maker.user_name} has joined Buddypix."
        when "decline_invitation"
          return "#{object.maker.user_name} declined to join Buddypix."
        when "post_photo"
          photo = object.object
          card = photo.album if photo
          return "#{object.maker.user_name} posts in your #{card.name}"
        when "like_photo"
          photo = object.object
          card = photo.album if photo
          return "#{object.maker.user_name} likes your post #{photo.title}"
        when "tagged"
          photo = object.object
          return "You have been tagged in a post #{photo.title}"
        end
      end

      def item
        object.object
      end

      def item_type
        item.class.name
      end
    end
  end
end
