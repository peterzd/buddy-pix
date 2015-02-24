# == Schema Information
#
# Table name: invitations
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  status      :string(255)
#  card_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Invitation < ActiveRecord::Base
  STATUS = { pending: "pending", accepted: "accepted", rejected: "rejected" }

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :card, class_name: "Album"

  def accept
    update status: STATUS[:accepted]
    self.receiver.joins_album self.card
    send_notification(maker: receiver, action: Notification::ACTION[:accept_invitation], object: self, receiver: sender)
  end

  def reject
    update status: STATUS[:rejected]
    send_notification(maker: receiver, action: Notification::ACTION[:decline_invitation], object: self, receiver: sender)
  end

  private
  def send_notification(options={})
    Notification.create options
  end
end

