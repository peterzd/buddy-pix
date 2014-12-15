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
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :page, type: String, desc: "request page"
        end
        post :my_wall_batch do
          authenticate!
          page = params[:page].to_i
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

        namespace :invitations do
          route_param :id do
            desc "accept an invitation"
            params do
              requires :access_token, type: String, desc: "the token of the user"
            end
            post :accept do
              authenticate!
              invitation = Invitation.find params[:id]
              if invitation.receiver == current_user
                invitation.accept
                present :status, "true"
                present :invitation_status, invitation.status
              else
                error!({status: "false", message: "can not do this action!"})
              end
            end

            desc "decline an invitation"
            params do
              requires :access_token, type: String, desc: "the token of the user"
            end
            post :decline do
              authenticate!
              invitation = Invitation.find params[:id]
              if invitation.receiver == current_user
                invitation.reject
                present :status, "true"
                present :invitation_status, invitation.status
              else
                error!({status: "false", message: "can not do this action!"})
              end
            end
          end

        end

        desc "returns the user's profile"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post :profile do
          authenticate!
          present :status, "true"
          present :user, current_user, with: API::Entities::User
        end

        desc "returns my created cards"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post :my_cards do
          authenticate!
          present :status, "true"
          present :user, current_user, with: API::Entities::User, type: :with_cards
        end

      end
    end
  end
end
