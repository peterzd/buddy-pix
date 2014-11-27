class Notification < ActiveRecord::Base
  ACTION = { join_card: "joins_card", accept_invitation: "accept_invitation",  decline_invitation: "decline_invitation", post_photo: "post_photo", comment: "comment_photo", like: "like_photo", tagged: "tagged"}

  belongs_to :maker, class_name: "User", foreign_key: :maker_id
  belongs_to :object, polymorphic: true
  belongs_to :receiver, class_name: "User", foreign_key: :receiver_id

  after_initialize :set_read

  private
  def set_read
    is_read ||= false
  end
end
