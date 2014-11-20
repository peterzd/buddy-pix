module API
  module Entities
    class Image < Grape::Entity
      expose :id
      expose :url

      private
      def url
        object.picture.url :medium
      end
    end
  end
end
