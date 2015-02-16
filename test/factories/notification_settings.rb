# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_setting do
    devise_token "MyString"
    user_id nil
    apn_options "MyText"
    email_options false
  end
end
