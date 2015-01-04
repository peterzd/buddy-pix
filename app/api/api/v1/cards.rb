Kaminari::Hooks.init
Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari

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
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :page, type: String, desc: "request page"
        end
        post "my_cards" do
          authenticate!
          page = params[:page].to_i
          cards = AlbumsQuery.user_following_cards(current_user, page * AlbumsQuery::NUMBER_FACTOR)
          present :status, "true"
          present :cards, cards, with: API::Entities::Card
        end

        desc "return 10 unfollowed cards by the user"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post "unfollowed_cards" do
          authenticate!
          cards = AlbumsQuery.unfollowed_cards_by(current_user).take(10)
          present :status, "true"
          present :cards, cards, with: API::Entities::Card
        end

        desc "search for cards"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :search_params, type: String, desc: "the search content"
          requires :page, type: String, desc: "the page for search content"
        end
        post "search_cards" do
          authenticate!
          cards = Album.search(params[:search_params]).page(params[:page].to_i).per(10).records
          present :status, "true"
          present :cards, cards, with: API::Entities::Card
        end

        desc "returns my hidden cards"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post "my_hidden_cards" do
          authenticate!
          cards = current_user.hidden_cards
          present :status, "true"
          present :cards, cards, with: API::Entities::Card
        end

        desc "returns one card"
        params do
          requires :id, type: String, desc: "card id"
        end
        post "get_card" do
          card = Album.find params[:id]
          present :status, "true"
          present :card, card, with: API::Entities::Card, type: :detail
        end

        desc "create a new card"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :name, type: String, desc: "the name of the card"
          requires :private, type: String, desc: "if the card is a private one"
          optional :description, type: String, desc: "the description of the card"
          requires :picture, type: String, desc: "cover picture of the card"
        end
        post "create" do
          authenticate!
          private_bool = params[:private] == "true"
          card = Album.new name: params[:name],
                           private: private_bool,
                           caption: params[:description],
                           creator: current_user

          if card.save
            image = Image.create image_data: params[:picture]
            card.set_cover_image image
            present :status, "true"
            present :card, card, with: API::Entities::Card
          else
            error!({status: "false", messages: "#{card.errors.full_messages}"})
          end
        end

        route_param :id do
          desc "hide a card"
          params do
            requires :access_token, type: String, desc: "user's access_token"
          end
          post "hide" do
            authenticate!
            card = Album.find params[:id]
            error!({status: "false", message: "unauthorized to do"}) unless AlbumPolicy.new(current_user, card).hide_card?
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

          desc "destroys a card"
          params do
            requires :access_token, type: String, desc: "user's access_token"
          end
          post "destroy" do
            authenticate!
            card = Album.find params[:id]
            card.destroy if current_user == card.creator
            present :status, "true"
          end

        end

      end
    end
  end
end
