class Notification < ActiveRecord::Base
  belongs_to :maker
  belongs_to :object, polymorphic: true
  belongs_to :receiver
end
