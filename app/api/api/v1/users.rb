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
        end
        post :sign_up do
          error!("password are not same") unless same_password?
          user = User.new(
            email: params[:email],
            password: params[:password]
          )
          if user.save
            present user, with: API::Entities::User
          else
            error!("#{user.errors.full_messages}")
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

        desc "upload profile photo"
        params do
          requires :picture, type: Rack::Multipart::UploadedFile, desc: "uploaded image"
        end
        post :profile_cover do
          authenticate!
          uploaded_pic = params[:picture]
          image = Image.create picture: uploaded_pic
          current_user.set_profile_cover image
          present current_user, with: API::Entities::User
        end

        desc "upload cover photo"
        params do
          requires :picture, type: Rack::Multipart::UploadedFile, desc: "uploaded image"
        end
        post :cover_photo do
          authenticate!
          uploaded_pic = params[:picture]
          image = Image.create picture: uploaded_pic
          current_user.set_cover_photo image
          present current_user, with: API::Entities::User
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
