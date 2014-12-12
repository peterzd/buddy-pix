module API
  module V1
    class Cards < Grape::API
      include API::V1::Helper

      resources :cards do
        desc "returns all cards"
        get do
          Album.all
        end

        desc "returns my following cards"
        get "my_cards" do
          authenticate!
          page = params[:page].to_i
          cards = AlbumsQuery.user_following_cards(current_user, page * AlbumsQuery::NUMBER_FACTOR)
          present :status, "true"
          present :cards, cards, with: API::Entities::Card, type: :detail
        end

        desc "returns one card"
        params do
          requires :id, type: String, desc: "card id"
        end
        get ":id" do
          card = Album.find params[:id]
          present card, with: API::Entities::Card
        end

      end
    end
  end
end
