# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  maker_id    :integer
#  action      :string(255)
#  object_id   :integer
#  object_type :string(255)
#  receiver_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  is_read     :boolean
#

class Notification < ActiveRecord::Base
  include Pushable

  ACTION = { join_card: "joins_card", accept_invitation: "accept_invitation",  decline_invitation: "decline_invitation", post_photo: "post_photo", comment: "comment_photo", like: "like_photo", tagged: "tagged"}

  belongs_to :maker, class_name: "User", foreign_key: :maker_id
  belongs_to :object, polymorphic: true
  belongs_to :receiver, class_name: "User", foreign_key: :receiver_id

  after_initialize :set_read

  after_create :push_notifications

  private
  def set_read
    self.is_read ||= false
  end

  def push_notifications
    push_user_notifications maker: self.maker, action: self.action, object: self.object, receiver: self.receiver
  end
end
