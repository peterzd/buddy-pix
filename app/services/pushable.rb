module Pushable
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def push_user_notifications(notification)
      text = message(notification)
      ApnsService.send_notification(notification.receiver, text)
    end

    def message(notification)
      case notification.action
      when "comment_photo"
        photo = notification.object
        return_str = ""
        if photo
          return_str = "#{notification.maker.user_name} comments on #{notification.object.title}."
        else
          return_str = "image has been removed by #{notification.maker.user_name}"
        end
        return return_str
      when "joins_card"
        return "#{notification.maker.user_name} has joined #{notification.object.name}."
      when "accept_invitation"
        return "#{notification.maker.user_name} has joined Buddypix."
      when "decline_invitation"
        return "#{notification.maker.user_name} declined to join Buddypix."
      when "post_photo"
        photo = notification.object
        card = photo.album if photo

        return_str = ""
        if photo
          return_str = "#{notification.maker.user_name} posts in your card #{card.name}"
        else
          return_str = "image has been removed by #{notification.maker.user_name}"
        end
        return return_str

      when "like_photo"
        photo = notification.object
        card = photo.album if photo
        return_str = ""
        if photo
          return_str = "#{notification.maker.user_name} likes your post #{photo.title}"
        else
          return_str = "image has been removed by #{notification.maker.user_name}"
        end
        return return_str
      when "tagged"
        photo = notification.object
        return_str = ""
        if photo
          return_str = "You have been tagged in a post #{photo.title}"
        else
          return_str = "image has been removed by #{notification.maker.user_name}"
        end
        return return_str
      end
    end

  end # end of Module InstanceMethods

end
