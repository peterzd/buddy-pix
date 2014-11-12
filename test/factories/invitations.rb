# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    sender nil
    invited_user nil
    status "MyString"
    card nil
  end
end
