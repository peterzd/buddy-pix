# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    role 1
    username "peterzd"

    factory :admin_user do
      role 0
      username "admin"
    end
  end

end
