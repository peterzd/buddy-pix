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

  store :apn_options, accessors: [:push_apn, :badge, :sound, :other], coder: JSON
  store :email_options, accessors: [:send_email], coder: JSON

  before_save :set_default_values

  private
  def set_default_values
    self.push_apn ||= true
    self.badge ||= 0
    self.sound ||= "default"
    self.other ||= ""
    self.send_email ||= "true"
  end

end
