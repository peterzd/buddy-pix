# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    sender nil
    receiver nil
    status "MyString"
    card nil
  end
end
