module API
  module V1
    class Root < Grape::API
      mount API::V1::Cards
      mount API::V1::Welcome
    end
  end
end
