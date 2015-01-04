module API
  module Entities
    class Invitation < Grape::Entity
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id
      expose :sender_name
      expose :sender_profile_cover
      expose :card

      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end

      private
      def sender_profile_cover
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{object.sender.profile_cover_url :thumb}"
      end

      def sender_name
        object.sender.user_name
      end

      def card
        privacy = object.card.private? ? "private" : "public"
        { id: object.card.id,
          name: object.card.name,
          privacy: privacy        
        }
      end

    end
  end
end
