module API
  module V1
    class Users < Grape::API
      include API::V1::Helper

      helpers do
        def same_password?
          params[:password] == params[:password_confirmation]
        end
      end

      resources :users do
        desc "signs up a user via REST api"
        params do
          requires :email, type: String, desc: "user's email"
          requires :password, type: String, desc: "user's password"
          requires :password_confirmation, type: String, desc: "user's password confirmation"
          requires :picture, type: String, desc: "profile image, base64 format"
        end
        post :sign_up do
          error!("password are not same") unless same_password?
          user = User.new(
            email: params[:email],
            password: params[:password]
          )

          if user.save
            image = Image.create image_data: params[:picture]
            user.set_profile_cover image

            present :status, "true"
            present :user, user, with: API::Entities::User, type: :access_token
          else
            error!({ status: "false", messages: "#{user.errors.full_messages}"})
          end
        end

        desc "signs in a registered user"
        params do
          requires :email, type: String, desc: "user's email"
          requires :password, type: String, desc: "user's password"
        end
        post :sign_in do
          user = User.find_by email: params[:email]
          error!("record not found") unless user
          if user.valid_password?(params[:password])
            present :status, "true"
            present :user, user, with: API::Entities::User, type: :access_token
          else
            error!({message: "email or password is not correct!", status: "false"})
          end
        end

        desc "my wall, my feed post"
        get :my_wall_batch do
          authenticate!
          page = params[:page]
          photos = PhotosQuery.user_wall_pics(current_user, page * PhotosQuery::NUMBER_FACTOR)

          present :status, "true"
          present :posts, photos, with: API::Entities::Photo
        end

        desc "get my invitations list"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post :my_invitations_list do
          authenticate!
          invitations = current_user.my_pending_invitations

          present :status, "true"
          present :invitations, invitations, with: API::Entities::Invitation

        end

        desc "returns the user's profile"
        get :profile do
          authenticate!
          present current_user, with: API::Entities::User
        end

        desc "returns my created cards"
        get :my_cards do
          authenticate!
          present current_user, with: API::Entities::User, type: :with_cards
        end

        desc "update user's profile"
        params do
          optional :first_name, type: String, desc: "user's first name"
          optional :last_name, type: String, desc: "user's last name"
          optional :email, type: String, desc: "user's email"
          optional :phone_number, type: String, desc: "user's phone number"
        end
        post :update_profile do
          authenticate!
          current_user.update!(
            first_name: params[:first_name],
            last_name: params[:last_name],
            email: params[:email],
            phone_number: params[:phone_number]
          )
          present current_user #, with: API::Entities::User
        end


      end
    end
  end
end
