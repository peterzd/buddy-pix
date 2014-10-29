# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "peterzd"

    factory :admin_user, class: AdminUser do
      username "peterzd"
    end
  end

end
