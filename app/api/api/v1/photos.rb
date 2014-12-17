module API
  module V1
    class Photos < Grape::API
      include API::V1::Helper

      resources :posts do
        desc "create a new photo"
        params do
          requires :access_token, type: String, desc: "the token of the user"
          requires :title, type: String, desc: "title of the post"
          requires :card_id, type: String, desc: "the card the post should belongs to"
          requires :picture, type: String, desc: "uploaded image"
          optional :description, type: String, desc: "description of the post"
          optional :tagged_friend_ids, type: Array do
            requires :id, type: String, desc: "the id of the user"
          end
        end
        post :upload_image do
          authenticate!
          image = Image.create image_data: params[:picture]
          card = Album.find params[:card_id].to_i
          photo = card.photos.build title: params[:title],
                                    description: params[:description],
                                    creator: current_user

          if PhotosService.new(photo).save_photo_api(image, params[:tagged_friend_ids])
            present :status, "true"
          else
            present :status, "false"
          end
        end

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
            requires :access_token, type: String, desc: "the token of the user"
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
            requires :access_token, type: String, desc: "the token of the user"
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


      end # end of resources :posts

    end
  end
end
