module API
  module Entities
    class Like < Grape::Entity
      expose :id
      expose :liker, using: API::Entities::User
      expose :mood, :created_at, :updated_at

    end
  end
end
