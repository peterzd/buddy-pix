module API
  module Entities
    class User < Grape::Entity
      expose :email, :username, :first_name, :last_name, :phone_number, :phone_number 
      expose :profile_cover, :cover_photo, using: API::Entities::Image
    end
  end
end
