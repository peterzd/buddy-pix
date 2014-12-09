module API
  module Entities
    class Photo < Grape::Entity
      expose :title, :description, :created_at, :updated_at
      expose :image_url

      private
      def image_url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{object.picture_url :medium}"
      end
    end
  end
end
