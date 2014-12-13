module API
  module V1
    class Accounts < Grape::API
      include API::V1::Helper

      resources :accounts do
        desc "get user's account info"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post do
          authenticate!
          created_cards = current_user.created_albums
          present :status, "true"
          present :account, current_user, with: API::Entities::User, type: :detail
          present :created_cards, created_cards, with: API::Entities::Card
        end
      end


    end
  end
end
