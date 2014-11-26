class Notification < ActiveRecord::Base
  ACTION = { join_card: "joins_card", accept_invitation: "accept invitation",  decline_invitation: " decline invitation", post_photo: "post photo", comment: "comment photo", like: "like photo", tagged: "tagged"}

  belongs_to :maker, class_name: "User", foreign_key: :maker_id
  belongs_to :object, polymorphic: true
  belongs_to :receiver, class_name: "User", foreign_key: :receiver_id
end
