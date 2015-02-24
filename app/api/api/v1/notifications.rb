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

        desc "get the user's notification settings"
        params do
          optional :apple_device_token, type: String, desc: "the token of the apple device"
        end
        post "get_settings" do
          noti_setting = NotificationSetting.find_by apple_device_token: params[:apple_device_token]
          present :status, "true"
          present :sound, noti_setting.apn_options[:sound]
          present :push_apn, noti_setting.apn_options[:push_apn]
          present :send_email, noti_setting.send_email
        end

        desc "update notification settings"
        params do
          optional :apple_device_token, type: String, desc: "the token of the apple device"
          optional :sound,              type: String, desc: "set the sound", values: ["true", "false"]
          optional :apn_push_noti,      type: String, desc: "set if push notifications", values: ["true", "false"]
          optional :email_noti,         type: String, desc: "set if push notifications", values: ["true", "false"]
        end
        post "settings" do
          noti_setting = NotificationSetting.find_by apple_device_token: params[:apple_device_token]
          noti_setting.update push_apn: params[:apn_push_noti]
          sound = if params[:sound] == "true"
                    "default"
                  else
                    ""
                  end

          noti_setting.update sound: sound
          noti_setting.update send_email: params[:email_noti]
          present :status, "true"
        end
      end # end of resources

    end
  end
end
