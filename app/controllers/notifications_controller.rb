class NotificationsController < ApplicationController
  def read
    @notification = Notification.find params[:id]
    @notification.update is_read: true
  end
end
