module API
  module Entities
    class Image < Grape::Entity
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id
      expose :url
      expose :height, unless: { type: :need_height }
      expose :ratio

      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end

      private
      def height
        (750 / object.ratio).to_i
      end

      def url
        host = Rails.env == "development" ? "http://localhost:3000" : "http://www.buddypix.net"
        "#{host}#{object.picture.url :large}"
      end
    end
  end
end
