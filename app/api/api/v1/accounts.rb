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

        desc "update user's cover photo image"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :picture, type: String, desc: "image of the cover photo"
        end
        post "update_cover_photo" do
          authenticate!
          image = Image.create image_data: params[:picture]
          current_user.set_cover_photo image
          present :status, "true"
          present :user, current_user, with: API::Entities::User
        end

        desc "update profile photo"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :picture, type: String, desc: "uploaded image"
        end
        post :update_profile_cover do
          authenticate!
          image = Image.create image_data: params[:picture]
          current_user.set_profile_cover image
          present :status, "true"
          present :user, current_user, with: API::Entities::User
        end

      end
    end
  end
end
