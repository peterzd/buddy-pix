class ApnsService
  class << self
    def send_notification(device_token)
      pusher = Grocer.pusher(
        certificate: Rails.root.join("apns-dev-cert.pem").to_s,      # required
        passphrase:  "",                       # optional
        gateway:     "gateway.push.apple.com", # optional; See note below.
        port:        2195,                     # optional
        retries:     3                         # optional
      )

      notification = Grocer::Notification.new(
        device_token:      device_token,
        alert:             "Hello from Grocer!",
        badge:             42,
        sound:             "default",         # optional
      )

      pusher.push(notification)
    end
  end
  
end
