module API
  module Entities
    class Image < Grape::Entity
      expose :id
      expose :url

      private
      def url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{object.picture.url :medium}"
      end
    end
  end
end
