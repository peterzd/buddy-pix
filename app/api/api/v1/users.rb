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
        desc "log in via omniauth"
        params do
          optional :apple_device_token, type: String, desc: "the token of the apple device"
          requires :email, type: String, desc: "user's email"
          requires :first_name, type: String, desc: "user's first_name"
          requires :last_name, type: String, desc: "user's last_name"
          requires :image_url, type: String, desc: "the url got from Facebook auth"
        end
        post :omni_login do
          user = User.where(email: params[:email]).first
          if user.nil?
            user = User.new email:      params[:email],
                            password:   Devise.friendly_token[0,20],
                            first_name: params[:first_name],
                            last_name:  params[:last_name],
                            username:   params[:username],   # assuming the user model has a name
                            image_url:  params[:image] # assuming the user model has an image
            user.skip_confirmation!
            user.save!
          end
          # user = User.where(email: params[:email]).first_or_create do |user|
          #   user.email = params[:email]
          #   user.password = Devise.friendly_token[0,20]
          #   user.first_name = params[:first_name]
          #   user.last_name = params[:last_name]
          #   user.image_url = params[:image_url]
          # end

          noti_setting = NotificationSetting.find_by apple_device_token: params[:apple_device_token]
          if noti_setting.nil?
            NotificationSetting.create apple_device_token: params[:apple_device_token], user: user
          else
            noti_setting.update user: user
          end

          present :status, "true"
          present :user, user, with: API::Entities::User, type: :access_token
        end

        desc "signs up a user via REST api"
        params do
          optional :apple_device_token, type: String, desc: "the token of the apple device"
          requires :email, type: String, desc: "user's email"
          requires :first_name, type: String, desc: "user's email"
          requires :last_name, type: String, desc: "user's email"
          requires :password, type: String, desc: "user's password"
          requires :password_confirmation, type: String, desc: "user's password confirmation"
          requires :picture, type: String, desc: "profile image, base64 format"
        end
        post :sign_up do
          error!({ status: "false", message: "password are not same" }) unless same_password?
          error!({ status: "false", message: "This Email ID has already been taken, please use another email id for signup" }) if User.find_by(email: params[:email])
          user = User.new(
            email: params[:email],
            password: params[:password],
            first_name: params[:first_name],
            last_name: params[:last_name]
          )

          if user.save
            image = Image.create image_data: params[:picture]
            user.set_profile_cover image
            NotificationSetting.create apple_device_token: params[:apple_device_token], user: user

            present :status, "true"
            present :user, user, with: API::Entities::User, type: :access_token
          else
            error!({ status: "false", message: "#{user.errors.full_messages}"})
          end
        end

        desc "signs in a registered user"
        params do
          optional :apple_device_token, type: String, desc: "the token of the apple device"
          requires :email, type: String, desc: "user's email"
          requires :password, type: String, desc: "user's password"
        end
        post :sign_in do
          user = User.find_by email: params[:email]
          error!({ status: "false", message: "user not exist" }) unless user
          error!({ status: "false", message: "Please confirm your account in your email first" }) if user.confirmed_at.nil?
          if user.valid_password?(params[:password])

            noti_setting = NotificationSetting.find_by apple_device_token: params[:apple_device_token]
            if noti_setting.nil?
              NotificationSetting.create apple_device_token: params[:apple_device_token], user: user
            else
              noti_setting.update user: user
            end

            present :status, "true"
            present :user, user, with: API::Entities::User, type: :access_token
          else
            error!({message: "email or password error", status: "false"})
          end
        end

        desc "forgot password"
        params do
          requires :email, type: String, desc: "user's email"
        end
        post :forgot_password do
          email = params[:email]
          user = User.find_by email: email
          error!({message: "email does not exist", status: "false"}) if user.nil?
          User.send_reset_password_instructions email: email

          present :status, "true"
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
        end # end of invitations

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
