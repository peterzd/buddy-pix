module Pushable
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def push_user_notifications(options={})
      ApnsService.send_notification(options[:receiver], "#{options[:maker].user_name} has joined your card, #{options[:object].name}")
    end
  end


end
