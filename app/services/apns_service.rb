class ApnsService
  class << self
    def send_notification(user, alert)
      notification_setting = user.notification_setting
      if notification_setting.nil?
        return
      else
        apple_token = notification_setting.apple_device_token
        push_notification(apple_token, alert, notification_setting.apn_options)
      end
    end

    def push_apple_notification(token, alert, apn_options)
      pusher = Grocer.pusher(
        certificate: Rails.root.join("apns-dev-cert.pem").to_s,      # required
        passphrase:  "",                       # optional
        port:        2195,                     # optional
        retries:     3                         # optional
      )

      notification = Grocer::Notification.new(
        device_token:      token,
        alert:             alert,
        sound:             apn_options[:sound],         # optional
      )

      pusher.push(notification)
    end
  end
  
end
