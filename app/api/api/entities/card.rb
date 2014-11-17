module API
  module Entities
    class Card < Grape::Entity

      expose :name, :private, :caption, :created_at, :last_name, :hidden
      expose :creator, using: API::Entities::User, unless: { type: :with_cards }
      expose :cover_image, using: API::Entities::Image
      expose :photos, using: API::Entities::Photo
    end
  end
end
