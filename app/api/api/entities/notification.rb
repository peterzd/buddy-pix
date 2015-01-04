module API
  module Entities
    class Notification < Grape::Entity
      format_with(:api_datetime) { |dt| dt.strftime("%Y-%m-%d %H:%M") }
      expose :id
      expose :maker, using: API::Entities::User
      expose :action
      expose :item
      expose :item_type
      expose :is_read
      expose :created_at, :updated_at

      with_options(format_with: :api_datetime) do
        expose :created_at
        expose :updated_at
      end

      private
      def item
        object.object
      end

      def item_type
        item.class.name
      end
    end
  end
end
