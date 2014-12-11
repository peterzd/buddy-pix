module API
  module V1
    class Photos < Grape::API
      include API::V1::Helper

      resources :posts do
        desc "returns a post"
        params do
          requires :id, type: String, desc: "photo id"
        end
        get ":id" do
          authenticate!
          photo = Photo.find params[:id]
          present :status, "true"
          present :post, photo, with: API::Entities::Photo
        end
      end

    end
  end

end
