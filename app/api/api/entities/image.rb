module API
  module Entities
    class Image < Grape::Entity
      expose :id
      expose :url
      expose :height, unless: { type: :need_height }
      expose :ratio

      private
      def height
        (750 / object.ratio).to_i
      end

      def url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{object.picture.url :medium}"
      end
    end
  end
end
