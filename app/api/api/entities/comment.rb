module API
  module Entities
    class Comment < Grape::Entity
      expose :commenter, using: API::Entities::User
      expose :content, :created_at, :updated_at

    end
  end
end