# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :support do
    sender_name "MyString"
    email "MyString"
    subject "MyString"
    message "MyText"
  end
end
