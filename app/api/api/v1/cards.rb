module API
  module V1
    class Cards < Grape::API
      version 'v1'
      format :json

      helpers do
        def warden
          env['warden']
        end

        def authenticated
          return true if warden.authenticated?
          params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
        end

        def current_user
          warden.user || @user
        end

        def authenticate!
          error!("401 Unauthorized", 401) unless authenticated
        end
      end


      resources :cards do
        desc "returns all cards"
        get do
          authenticate!
          Album.all
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
