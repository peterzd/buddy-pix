module API
  module Entities
    class Photo < Grape::Entity
      expose :title, :description, :created_at, :updated_at
      expose :image_url

      private
      def image_url
        object.picture_url
      end
    end
  end
end
