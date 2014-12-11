module API
  module V1
    class Root < Grape::API
      mount API::V1::Cards
      mount API::V1::Welcome
      mount API::V1::Users
      mount API::V1::Photos
    end
  end
end
