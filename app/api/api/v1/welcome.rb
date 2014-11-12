module API
  module V1
    class Welcome < Grape::API
      version 'v1'
      format :json

      resource :welcome do
        desc "Returns list all all blogs"
        get :blog do
          Blog.order :created_at
        end


      end
    end
  end
end
