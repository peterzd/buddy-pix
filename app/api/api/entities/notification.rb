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
          photo = object.object
          return_str = ""
          if photo
            return_str = "#{object.maker.user_name} comments on #{object.object.title}."
          else
            return_str = "image has been removed by #{object.maker.user_name}"
          end
          return return_str
        when "joins_card"
          return "#{object.maker.user_name} has joined #{object.object.name}."
        when "accept_invitation"
          return "#{object.maker.user_name} has joined Buddypix."
        when "decline_invitation"
          return "#{object.maker.user_name} declined to join Buddypix."
        when "post_photo"
          photo = object.object
          card = photo.album if photo

          return_str = ""
          if photo
            return_str = "#{object.maker.user_name} posts in your #{card.name}"
          else
            return_str = "image has been removed by #{object.maker.user_name}"
          end
          return return_str

        when "like_photo"
          photo = object.object
          card = photo.album if photo
          return_str = ""
          if photo
            return_str = "#{object.maker.user_name} likes your post #{photo.title}"
          else
            return_str = "image has been removed by #{object.maker.user_name}"
          end
          return return_str
        when "tagged"
          photo = object.object
          return_str = ""
          if photo
            return_str = "You have been tagged in a post #{photo.title}"
          else
            return_str = "image has been removed by #{object.maker.user_name}"
          end
          return return_str
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
