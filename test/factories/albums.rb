# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :album do
    name "MyString"
    private false
    caption "MyText"
  end
end
