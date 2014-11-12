module API
  module Entities
    class User < Grape::Entity
      expose :email
      expose :username
      expose :first_name
      expose :last_name
      expose :phone_number
      expose :phone_number
    end
  end
end
