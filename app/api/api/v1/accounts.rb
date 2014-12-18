module API
  module V1
    class Accounts < Grape::API
      include API::V1::Helper

      resources :accounts do
        desc "get user's account info with created cards"
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

        desc "send a feedback to system manager"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :subject, type: String, desc: "subject of the feedback"
          requires :message, type: String, desc: "message of the feedback"
        end
        post :feedback do
          authenticate!
          support = Support.new sender_name: current_user.user_name,
                                   email: current_user.email,
                                   subject: params[:subject],
                                   message: params[:message]
          if support.save
            SupportMailer.support_email(support).deliver
            present :status, "true"
          end
        end

        desc "update user's profile"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          optional :first_name, type: String, desc: "user's first name"
          optional :last_name, type: String, desc: "user's last name"
          optional :email, type: String, desc: "user's email"
          optional :phone_number, type: String, desc: "user's phone number"
          optional :password, type: Hash do
            requires :old, type: String, desc: "the old password"
            requires :new, type: String, desc: "the old password"
          end
        end
        post :update_profile do
          authenticate!
          if params[:first_name]
            current_user.update first_name: params[:first_name]
          end

          if params[:last_name]
            current_user.update last_name: params[:last_name]
          end

          if params[:email]
            current_user.update email: params[:email]
          end

          if params[:phone_number]
            current_user.update phone_number: params[:phone_number]
          end

          if params[:password]
            old = params[:password][:old]
            error!({status: "false", message: "old password is invalid"}) unless current_user.valid_password?(old)
            error!({status: "false", message: current_user.errors.full_messages.first}) unless current_user.update(password: params[:password][:new])
          end

          present :status, "true"
          present :user, current_user, with: API::Entities::User
        end


      end # end of resources accounts
    end
  end
end
