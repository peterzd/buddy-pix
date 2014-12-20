module API
  module Entities
    class Notification < Grape::Entity
      expose :id
      expose :maker, using: API::Entities::User
      expose :action
      expose :item
      expose :item_type
      expose :is_read
      expose :created_at, :updated_at

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
