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
          present :cards, cards, with: API::Entities::Card
        end

        desc "returns my hidden cards"
        get "my_hidden_cards" do
          authenticate!
          cards = current_user.hidden_cards
          present :status, "true"
          present :cards, cards, with: API::Entities::Card
        end

        desc "returns one card"
        params do
          requires :id, type: String, desc: "card id"
        end
        get ":id" do
          card = Album.find params[:id]
          present :status, "true"
          present :card, card, with: API::Entities::Card, type: :detail
        end

        route_param :id do
          desc "hide a card"
          params do
            requires :access_token, type: String, desc: "user's access_token"
          end
          post "hide" do
            authenticate!
            card = Album.find params[:id]
            card.update hidden: true
            present :status, "true"
          end

          desc "unhide a card"
          params do
            requires :access_token, type: String, desc: "user's access_token"
          end
          post "unhide" do
            authenticate!
            card = Album.find params[:id]
            card.update hidden: false
            present :status, "true"
          end

        end

      end
    end
  end
end
