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

        desc "invites others in app contacts"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :card_id, type: String, desc: "the card invited to"
          requires :emails, type: Array, desc: "invited users"
          optional :content, type: String, desc: "content of the email"
        end
        post :email do
          authenticate!
          card = Album.find params[:card_id].to_i
          emails = params[:emails]
          email_host = request.host_with_port
          content = params[:content]

          InvitationsService.send_email(current_user, card, emails, content, email_host)
          present :status, "true"
        end
      end # end of resource
    end
  end
end
