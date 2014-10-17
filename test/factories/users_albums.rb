# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :users_album, :class => 'UsersAlbums' do
    user nil
    album nil
    access_type 1
  end
end
