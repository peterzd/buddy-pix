# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment, :class => 'Comments' do
    commenter nil
    commentable nil
    content "MyText"
  end
end
