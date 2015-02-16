require "test_helper"

describe NotificationSetting do
  let(:notification_setting) { create :notification_setting }

  it "has some default values if noting set" do
    notification_setting.apn_options[:sound].must_equal "default"
    notification_setting.email_options[:send_email].must_equal "true"
  end
end
