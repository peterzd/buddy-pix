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
            present user, using: API::Entities::User
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
            # success
            present user
          end
        end
      end


    end
  end
end
