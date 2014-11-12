module API
  module Entities
    class Card < Grape::Entity

      expose :name
      expose :private
      expose :caption
      expose :created_at
      expose :last_name
      expose :hidden
      expose :creator, using: API::Entities::User
      # expose :cover_image, using: API::Image
    end
  end
end
