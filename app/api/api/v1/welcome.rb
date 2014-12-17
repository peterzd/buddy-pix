module API
  module V1
    class Welcome < Grape::API
      include API::V1::Helper

      resource :welcome do
        desc "Returns list all all blogs"
        post :blogs do
          Blog.order :created_at
        end

        desc "get privacy content"
        post :privacy do
          content = StaticPages.find_by(name: "privacy").content
          present :status, 'true'
          present :content, content
        end

        desc "get terms content"
        post :terms do
          content = StaticPages.find_by(name: "terms").content
          present :status, 'true'
          present :content, content
        end

        desc "fetch all users id and name"
        params do
          requires :access_token, type: String, desc: "the token of the user"
        end
        post :users do
          authenticate!
          users = User.all_other_users(current_user)
          present :status, "true"
          present :users, users, with: API::Entities::User
        end

      end
    end
  end
end
