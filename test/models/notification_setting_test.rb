require "test_helper"

describe NotificationSetting do
  let(:notification_setting) { NotificationSetting.new }

  it "must be valid" do
    notification_setting.must_be :valid?
  end
end
