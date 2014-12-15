module API
  module V1
    class Photos < Grape::API
      include API::V1::Helper

      resources :posts do
        desc "returns a post"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post ":id" do
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
              present :likes_count, photo.likes.count
            end
          end

          desc "comments on a photo"
          params do
            requires :content, type: String, desc: "the content of the comment"
            optional :picture, type: String, desc: "comment image"
          end
          post :comment do
            authenticate!
            photo = Photo.find params[:id]
            if params[:picture]
              p "will create image"
              image = Image.create image_data: params[:picture]
              current_user.comments_photo photo, params[:content], image
            else
              current_user.comments_photo photo, params[:content]
            end
            present :status, "true"
            present :comments_count, photo.comments.count
          end


        end
      end

    end
  end

end
