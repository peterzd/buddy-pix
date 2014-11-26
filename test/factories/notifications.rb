# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    maker nil
    action "MyString"
    object nil
    receiver nil
  end
end
