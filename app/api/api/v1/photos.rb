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

        route_param :id do
          desc "likes a photo"
          params do
            requires :mood, type: String, desc: "the mood of the like"
          end
          post "like" do
            authenticate!
            photo = Photo.find params[:id]
            if current_user.liked_photos.include? photo
              error!({ message: "already liked this post", status: "false"}) if current_user.liked_photos.include?(photo)
            else
              current_user.like_photo photo, mood: params[:mood]
              present :status, "true"
              present :post, photo, with: API::Entities::Photo
            end
          end

        end
      end

    end
  end

end
