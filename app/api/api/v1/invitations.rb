module API
  module V1
    class Invitations < Grape::API
      include API::V1::Helper

      resource :invitations do
        desc "invites others in app contacts"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :card_id, type: String, desc: "the card invited to"
          requires :user_ids, type: Array, desc: "invited users"
        end
        post :app_contact do
          authenticate!
          card = Album.find params[:card_id].to_i
          user_ids = params[:user_ids].map &:to_i
          user_ids.each do |id|
            current_user.send_invitation id, card
          end
          present :status, "true"
        end
      end
    end
  end
end
