# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    liker nil
    mood 1
    likeable nil
  end
end
