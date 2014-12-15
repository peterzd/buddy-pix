module API
  module V1
    class Welcome < Grape::API
      version 'v1'
      format :json

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

      end
    end
  end
end
