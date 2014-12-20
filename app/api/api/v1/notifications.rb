module API
  module V1
    class Notifications < Grape::API
      include API::V1::Helper

      resources :notifications do
        desc "get the user's notifications"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post do
          authenticate!
          notifications = current_user.unread_notifications
          present :status, "true"
          present :notifications, notifications, with: API::Entities::Notification
        end

        desc "read the notification"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :id, type: String, desc: "the notification's id"
        end
        post "read" do
          authenticate!
          notification = Notification.find params[:id]
          notification.update is_read: true
          present :status, "true"
        end

      end # end of resources
    end
  end
end
