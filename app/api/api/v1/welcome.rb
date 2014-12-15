module API
  module V1
    class Welcome < Grape::API
      version 'v1'
      format :json

      resource :welcome do
        desc "Returns list all all blogs"
        post :blogs do
          Blog.order :created_at
        end

        desc "Creates a support feedback"
        params do
          requires :sender_name, type: String, desc: "Sender's name"
          requires :email, type: String, desc: "Sender's email"
          requires :subject, type: String, desc: "Message's subject"
          requires :message, type: String, desc: "Feedback's message"
        end
        post :support do
          Support.create(
            sender_name: params[:sender_name],
            email: params[:email],
            subject: params[:subject],
            message: params[:message]
          )
        end
      end
    end
  end
end
