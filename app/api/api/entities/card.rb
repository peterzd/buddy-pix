module API
  module Entities
    class Card < Grape::Entity

      expose :name, :private, :caption, :created_at, :last_name, :hidden
      expose :creator, using: API::Entities::User
      expose :cover_image, using: API::Entities::Image
    end
  end
end
