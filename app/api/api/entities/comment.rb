module API
  module Entities
    class Comment < Grape::Entity
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id
      expose :commenter, using: API::Entities::User
      expose :content, :created_at, :updated_at

      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
