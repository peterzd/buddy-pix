# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation_token do
    token "MyString"
    inviter nil
    action nil
    invitation_type "MyString"
    info "MyString"
    expired false
  end
end
