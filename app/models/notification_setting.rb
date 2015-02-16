# == Schema Information
#
# Table name: notification_settings
#
#  id                 :integer          not null, primary key
#  apple_device_token :string(255)
#  user_id            :integer
#  apn_options        :text
#  email_options      :text
#  created_at         :datetime
#  updated_at         :datetime
#

class NotificationSetting < ActiveRecord::Base
  belongs_to :user
end
